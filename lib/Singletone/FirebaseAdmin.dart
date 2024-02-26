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
}