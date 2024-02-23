import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Custom/CButton.dart';
import '../Custom/CTextF.dart';

class RegisterView extends StatelessWidget{

  late BuildContext _context;

  TextEditingController tUsername=TextEditingController();
  TextEditingController tPassword=TextEditingController();
  TextEditingController tRespass=TextEditingController();

  SnackBar snackBar = SnackBar(
    content: Text('Yay! A SnackBar!'),
  );

  void onClickCancelar(){
    Navigator.of(_context).pushNamed("/loginview");
  }
  void onClickAceptar() async {
    //print("DEBUG>>>> "+usernameController.text);
    if(tPassword.text==tRespass.text) {
      try {

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: tUsername.text,
          password: tPassword.text,
        );

        Navigator.of(_context).pushNamed("/loginview");

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
    else{
      ScaffoldMessenger.of(_context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _context=context;

    Column columna = Column(children: [
      Text("SNKRSell",style: TextStyle(fontSize: 25)),

      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: CTextF(tController: tUsername,
          hint:'Escribe tu usuario', password: false,),
      ),

      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: CTextF(tController: tPassword,hint:'Escribe tu Contraseña', password: true,),
      ),

      Padding(padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: CTextF(tController: tRespass, hint:'Repite tu Contraseña', password: true,),
      ),

      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CButton(text: "Aceptar", onPressed: onClickAceptar),
          CButton(text: "Cancelar", onPressed: onClickCancelar)
        ],)


    ],);

    AppBar appBar = AppBar(
      title: const Text('Registrarse'),
      centerTitle: true,
      shadowColor: Colors.white,
      backgroundColor: Colors.black,
    );

    Scaffold scaf=Scaffold(body: columna,
      appBar: appBar,);

    return scaf;
  }

}