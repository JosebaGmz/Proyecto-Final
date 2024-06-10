import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FirestoreObjects/FbPost.dart';
import '../FirestoreObjects/FbUsuario.dart';
import 'FirebaseAdmin.dart';
import 'GeolocAdmin.dart';
//import 'HttpAdmin.dart';
import 'PlatformAdmin.dart';

class DataHolder {

  static final DataHolder _dataHolder = DataHolder._internal();

  String sNombre="SNKRS";
  late String sPostTitle;
  FbPost? selectedPost;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAdmin fbadmin=FirebaseAdmin();
  GeolocAdmin geolocAdmin = GeolocAdmin();
  late PlatformAdmin platformAdmin;
  //HttpAdmin httpAdmin=HttpAdmin();
  FbUsuario? usuario;

  DataHolder._internal() {

  }

  void initDataHolder(){
    sPostTitle="Titulo de Post";
    //loadCachedFbPost();
  }

  void initPlatformAdmin(BuildContext context){
    platformAdmin=PlatformAdmin(context: context);
  }

  factory DataHolder(){
    return _dataHolder;
  }

  void insertPostEnFB(FbPost postNuevo) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> coleccionesRef = db.collection("ColeccionZapatillas");
    bool usuarioExiste = await coleccionesRef.doc(uid).get().then((doc) =>doc.exists);

    CollectionReference<Map<String, dynamic>> zapatillasRef = coleccionesRef.doc(uid).collection("ZapatillasStock");

    bool subcoleccionExiste = await zapatillasRef.get().then((querySnapshot) => querySnapshot.docs.isNotEmpty);

    await zapatillasRef.add(postNuevo.toFirestore());
  }

  void saveSelectedPostInCache() async{
    if(selectedPost!=null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fbpost_titulo', selectedPost!.titulo);
      prefs.setString('fbpost_cuerpo', selectedPost!.cuerpo);
      prefs.setString('fbpost_surlimg', selectedPost!.sUrlImg);
      prefs.setInt('fbpost_talla', selectedPost!.talla);
      prefs.setString('fbpost_marca', selectedPost!.marca);
      prefs.setString('fbpost_color', selectedPost!.color);
      prefs.setInt('fbpost_precio', selectedPost!.precio);
    }

  }

  Future<FbUsuario?> loadFbUsuario() async{
    String uid=FirebaseAuth.instance.currentUser!.uid;

    DocumentReference<FbUsuario> ref=db.collection("Usuarios")
        .doc(uid)
        .withConverter(fromFirestore: FbUsuario.fromFirestore,
      toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),);


    DocumentSnapshot<FbUsuario> docSnap=await ref.get();
    print("docSnap DE DESCARGA loadFbUsuario------------->>>> ${docSnap.data()}");
    usuario=docSnap.data();
    return usuario;
  }

  Future<FbPost?> loadFbPost() async{
    if(selectedPost!=null) return selectedPost;

    await Future.delayed(Duration(seconds: 10));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fbpost_titulo = prefs.getString('fbpost_titulo');
    fbpost_titulo ??= "";
    String? fbpost_cuerpo = prefs.getString('fbpost_cuerpo');
    if(fbpost_cuerpo==null){
      fbpost_cuerpo="";
    }
    String? fbpost_surlimg = prefs.getString('fbpost_surlimg');
    if(fbpost_surlimg==null){
      fbpost_surlimg="";
    }
    int? fbpost_talla = prefs.getInt('fbpost_talla');
    if(fbpost_talla == null){
      fbpost_talla = 0;
    }

    String? fbpost_marca = prefs.getString('fbpost_marca');
    if(fbpost_marca==null){
      fbpost_marca="";
    }

    String? fbpost_color = prefs.getString('fbpost_color');
    if(fbpost_color==null){
      fbpost_color="";
    }

    int? fbpost_precio = prefs.getInt('fbpost_precio');
    if(fbpost_precio == null){
      fbpost_precio = 1;
    }

    String? fbpost_telefono = prefs.getString('fbpost_telefono');
    if(fbpost_telefono==null){
      fbpost_telefono="";
    }

    selectedPost=FbPost(titulo: fbpost_titulo, cuerpo: fbpost_cuerpo, sUrlImg: fbpost_surlimg, talla: fbpost_talla, marca: fbpost_marca, color: fbpost_color,precio: fbpost_precio,telefono: fbpost_telefono);
    return selectedPost;
  }

  void suscribeACambiosGPSUsuario(){
    geolocAdmin.registrarCambiosLoc(posicionDelMovilCambio);

  }

  void posicionDelMovilCambio(Position? position){
    print("HE CAMBIADO DE POS:------>>>>"+position.toString());
    usuario!.geoloc=GeoPoint(position!.latitude, position.longitude);
    fbadmin.actualizarPerfilUsuario(usuario!);
  }

  Future<void> updateZapatillasStock(Map<String, dynamic> dataToUpdate, String id) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> zapatillasRef =
    db.collection("ColeccionZapatillas").doc(uid).collection("ZapatillasStock");

    // Actualiza solo el documento con el ID proporcionado
    await zapatillasRef.doc(id).update(dataToUpdate);
  }

  Future<void> deleteZapatilla(String zapatillaId) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String userId = uid;

      DocumentReference zapatillaRef = db
          .collection("ColeccionZapatillas")
          .doc(userId)
          .collection("ZapatillasStock")
          .doc(zapatillaId);

      DocumentSnapshot zapatillaSnapshot = await zapatillaRef.get();

      // Verificar si el documento existe antes de intentar borrarlo
      if (zapatillaSnapshot.exists) {
        // Obtener el campo 'id' del documento
        String docId = zapatillaSnapshot.get('id') as String;

        // Referencia al documento usando el valor del campo 'id'
        DocumentReference docToDelete = db
            .collection("ColeccionZapatillas")
            .doc(userId)
            .collection("ZapatillasStock")
            .doc(docId);

        // Borrar el documento
        await docToDelete.delete();
        print("Documento eliminado exitosamente.");
      } else {
        print("El documento no existe.");
      }
    } catch (error) {
      print("Error al eliminar el post: $error");
      // Manejar el error según sea necesario
    }
  }
}