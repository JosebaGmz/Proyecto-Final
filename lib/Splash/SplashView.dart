import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../FirestoreObjects/FbUsuario.dart';

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }

  void checkSession() async{
    await Future.delayed(Duration(seconds: 4));
    if (FirebaseAuth.instance.currentUser != null) {

      String uid=FirebaseAuth.instance.currentUser!.uid;

      DocumentReference<FbUsuario> ref=db.collection("Usuarios")
          .doc(uid)
          .withConverter(fromFirestore: FbUsuario.fromFirestore,
        toFirestore: (FbUsuario usuario, _) => usuario.toFirestore(),);


      DocumentSnapshot<FbUsuario> docSnap=await ref.get();
      FbUsuario usuario=docSnap.data()!;

      if(usuario!=null){
        print("EL NOMBRE DEL USUARIO LOGEADO ES: "+usuario.nombre);
        print("LA EDAD DEL USUARIO LOGEADO ES: "+usuario.edad.toString());
        Navigator.of(context).popAndPushNamed("/drawerview");
      }
      else{
        Navigator.of(context).popAndPushNamed("/perfilview");
      }

    }
    else{
      Navigator.of(context).popAndPushNamed("/loginview");
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center, // Centrar los elementos verticalmente
      children: [
        Image.network(
          "https://i.pinimg.com/originals/2e/88/36/2e88365a6db490d968273793773f2ae7.jpg",
          width: 300,
          height: 450,
        ),
        CircularProgressIndicator(),
      ],
    );
    return Container(
      color: Colors.white, // Establecer el color de fondo como blanco
      child: column,
    );

  }


}