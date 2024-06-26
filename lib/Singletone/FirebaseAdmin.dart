import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_psp_pmdm/FirestoreObjects/FbPost.dart';

import '../FirestoreObjects/FbUsuario.dart';

class FirebaseAdmin{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;


  void agregarPerfilUsuario(FbUsuario usuario) async{
    //Crear documento con ID NUESTRO (o proporsionado por nosotros)
    String uidUsuario= FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }

  void initZapatillasStock(FbPost post) async{
    String uidUsuario= FirebaseAuth.instance.currentUser!.uid;
    DocumentReference docUsuario = FirebaseFirestore.instance.collection('ColeccionZapatillas').doc(uidUsuario);
    await docUsuario.collection('ZapatillasStock').doc().set({});
    //CollectionReference subColeccionZapasStock = docUsuario.collection('ZapatillasStock');
  }

  void actualizarPerfilUsuario(FbUsuario usuario) async{
    //Crear documento con ID NUESTRO (o proporsionado por nosotros)
    String uidUsuario= FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());
  }

  Future<List<FbPost>> descargarPosts() async {
    List<FbPost> zapatillas = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    String userId = uid;

    QuerySnapshot<Map<String, dynamic>> zapasSnapshot = await db
        .collectionGroup("ZapatillasStock")
        .get();

    zapasSnapshot.docs.forEach((zapaDoc) {
      FbPost anuncio = FbPost.fromFirestore(zapaDoc, null);
      zapatillas.add(anuncio);
    });
    print(zapatillas.length);
    return zapatillas;
  }

  Future<List<FbPost>> descargarPostsUnicos() async {
    List<FbPost> zapatillas = [];
    FirebaseFirestore db = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String userId = uid;

    QuerySnapshot<Map<String, dynamic>> zapasSnapshot = await db
        .collection("ColeccionZapatillas")
        .doc(userId)
        .collection("ZapatillasStock")
        .get();

    zapasSnapshot.docs.forEach((zapaDoc) {
      FbPost anuncio = FbPost.fromFirestore(zapaDoc, null);
      zapatillas.add(anuncio);
    });
    print(zapatillas.length);
    return zapatillas;
  }

  ///SISTEMA DE LIKES

  Future<List<FbPost>> descargarPostsFavoritos() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<FbPost> favoritos = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    List<String> zapatillasDocIds = [];
    List<String> zapatillasStockDocIds = [];

    try {
      // Obtener los documentos de la colección 'likes' para el usuario actual
      QuerySnapshot<Map<String, dynamic>> likesSnapshot = await db
          .collection('Likes')
          .where('userId', isEqualTo: uid)
          .get();

      // Obtener los IDs de los posts favoritos
      List<String> favoritePostIds = likesSnapshot.docs.map((doc) => doc['postId'] as String).toList();
      print("favoritePostIds: $favoritePostIds");

      // Obtener los documentos de la colección 'ColeccionZapatillas'
      QuerySnapshot<Map<String, dynamic>> zapatillasSnapshot = await db.collection('ColeccionZapatillas').get();

      // Iterar sobre los documentos de la colección 'ColeccionZapatillas'
      for (var zapatillasDoc in zapatillasSnapshot.docs) {
        String zapatillasDocId = zapatillasDoc.id;
        zapatillasDocIds.add(zapatillasDocId);

        // Obtener los documentos de la subcolección 'ZapatillasStock' para el documento actual de 'ColeccionZapatillas'
        QuerySnapshot<Map<String, dynamic>> zapatillasStockSnapshot = await db
            .collection('ColeccionZapatillas')
            .doc(zapatillasDocId)
            .collection('ZapatillasStock')
            .get();

        // Iterar sobre los documentos de la subcolección 'ZapatillasStock' y agregar los favoritos a la lista
        for (var postDoc in zapatillasStockSnapshot.docs) {
          String zapatillasStockDocId = postDoc.id;
          zapatillasStockDocIds.add(zapatillasStockDocId);

          if (favoritePostIds.contains(postDoc.id)) {
            FbPost post = FbPost.fromFirestore(postDoc, null);
            favoritos.add(post);
            print('Post añadido: ${postDoc.id}');
          }
        }
      }
    } catch (e) {
      print("Error al descargar los posts favoritos: $e");
    }

    print('Número de documentos en ColeccionZapatillas: ${zapatillasDocIds.length}');
    print('IDs de documentos en ColeccionZapatillas: $zapatillasDocIds');
    print('Número de documentos en ZapatillasStock: ${zapatillasStockDocIds.length}');
    print('IDs de documentos en ZapatillasStock: $zapatillasStockDocIds');
    print('Número de anuncios descargados: ${favoritos.length}');

    return favoritos;
  }


  Future<void> addLikeToPost(String postId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference likesRef = db.collection("Likes");

    await likesRef.add({
      'postId': postId,
      'userId': uid,
      'likedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeLikeFromPost(String postId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference likesRef = db.collection("Likes");

    QuerySnapshot querySnapshot = await likesRef
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: uid)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<int> getLikesCount(String postId) async {
    QuerySnapshot likesSnapshot = await db
        .collection("Likes")
        .where('postId', isEqualTo: postId)
        .get();

    return likesSnapshot.size;
  }

  Future<bool> isPostLikedByUser(String postId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot likeSnapshot = await db
        .collection("Likes")
        .where('postId', isEqualTo: postId)
        .where('userId', isEqualTo: uid)
        .get();

    return likeSnapshot.docs.isNotEmpty;
  }

}