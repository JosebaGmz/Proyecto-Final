import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/CButton.dart';
import 'package:proyecto_psp_pmdm/Custom/CTextF.dart';

import '../FirestoreObjects/FbUsuario.dart';

class PerfilView extends StatelessWidget{

  TextEditingController tecNombre=TextEditingController();
  TextEditingController tecEdad=TextEditingController();
  TextEditingController tecTalla=TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BuildContext _context;

  void onClickAceptar() async{

    FbUsuario usuario = new FbUsuario(nombre: tecNombre.text,
        edad: int.parse(tecEdad.text), talla: double.parse(tecTalla.text));


    //Crear documento con ID NUESTRO (o proporsionado por nosotros)
    String uidUsuario= FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Usuarios").doc(uidUsuario).set(usuario.toFirestore());

    Navigator.of(_context).popAndPushNamed("/homeview");
  }

  void onClickCancelar(){

  }

  @override
  Widget build(BuildContext context) {
    this._context=context;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil'),
          centerTitle: true,
          shadowColor: Colors.pink,
          backgroundColor: Colors.deepOrange,
        ),
        body:
        ConstrainedBox(constraints: BoxConstraints(
          minWidth: 500,
          minHeight: 700,
          maxWidth: 1000,
          maxHeight: 900,
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CTextF(hint: "Nombre",tController: tecNombre,password: false,),
              CTextF(hint: "Edad",tController: tecEdad,password: false,),
              CTextF(hint: "Talla", tController: tecTalla, password: false),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CButton(text:"Aceptar",onPressed: onClickAceptar,),
                    //TextButton( onPressed: onClickCancelar, child: Text("Cancelar"),)
                  ]
              )
            ],
          ),)
    );

  }



}