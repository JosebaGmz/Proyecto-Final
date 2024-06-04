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

    try {
      // Obtener los documentos de la colección 'likes' para el usuario actual
      QuerySnapshot<Map<String, dynamic>> likesSnapshot = await db
          .collection('Likes')
          .where('userId', isEqualTo: uid)
          .get();

      // Obtener los IDs de los posts favoritos
      List<String> favoritePostIds = likesSnapshot.docs.map((doc) => doc['postId'] as String).toList();
      print("favoritePostIds: $favoritePostIds");

      // Iterar sobre los documentos de la colección 'ColeccionZapatillas' y sus subcolecciones 'ZapatillasStock'
      QuerySnapshot<Map<String, dynamic>> zapatillasSnapshot = await db.collection('ColeccionZapatillas').get();

      for (var zapatillasDoc in zapatillasSnapshot.docs) {
        // Obtener los documentos de la subcolección 'ZapatillasStock' para el documento actual de 'ColeccionZapatillas'
        QuerySnapshot<Map<String, dynamic>> zapatillasStockSnapshot = await db
            .collection('ColeccionZapatillas')
            .doc(zapatillasDoc.toString())
            .collection('ZapatillasStock')
            .get();

        print(zapatillasDoc.toString());

        // Iterar sobre los documentos de la subcolección 'ZapatillasStock' y agregar los favoritos a la lista
        zapatillasStockSnapshot.docs.forEach((postDoc) {
          if (favoritePostIds.contains(postDoc.id)) {
            FbPost post = FbPost.fromFirestore(postDoc, null);
            favoritos.add(post);
          }
        });
      }

      return favoritos;
    } catch (e) {
      print("Error al descargar los posts favoritos: $e");
      return [];
    }
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