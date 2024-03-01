import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proyecto_psp_pmdm/Custom/CButton.dart';
import 'package:proyecto_psp_pmdm/Custom/CTextF.dart';

import '../FirestoreObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class PhoneLoginView extends StatefulWidget{
  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {

  TextEditingController tecPhone=TextEditingController();
  TextEditingController tecVerify=TextEditingController();
  String sVerificationCode="";
  bool blMostrarVerificacion=false;

  void enviarTelefonoPressed() async{
    String sTelefono=tecPhone.text;

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: sTelefono,
        verificationCompleted: verificacionCompletada,
        verificationFailed: verificacionFallida,
        codeSent: codigoEnviado,
        codeAutoRetrievalTimeout: tiempoDeEsperaAcabado);
  }

  void enviarVerifyPressed() async{
    String smsCode = tecVerify.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(verificationId: sVerificationCode, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    FbUsuario? usuario= await DataHolder().loadFbUsuario();
    Position pos=await DataHolder().geolocAdmin.determinePosition();
    //print("----------->>>>>>>>>>>>>>>>>>> "+pos.toString());
    DataHolder().suscribeACambiosGPSUsuario();

    if(usuario!=null){
      print("EL NOMBRE DEL USUARIO LOGEADO ES: "+usuario.nombre);
      print("LA EDAD DEL USUARIO LOGEADO ES: "+usuario.edad.toString());
      Navigator.of(context).popAndPushNamed("/drawerview");
    }
    else{
      Navigator.of(context).popAndPushNamed("/perfilview");
    }
  }

  void verificacionCompletada(PhoneAuthCredential credencial) async{
    await FirebaseAuth.instance.signInWithCredential(credencial);

    FbUsuario? usuario= await DataHolder().loadFbUsuario();
    Position pos=await DataHolder().geolocAdmin.determinePosition();
    //print("----------->>>>>>>>>>>>>>>>>>> "+pos.toString());
    DataHolder().suscribeACambiosGPSUsuario();

    if(usuario!=null){
      print("EL NOMBRE DEL USUARIO LOGEADO ES: "+usuario.nombre);
      print("LA EDAD DEL USUARIO LOGEADO ES: "+usuario.edad.toString());
      Navigator.of(context).popAndPushNamed("/drawerview");
    }
    else{
      Navigator.of(context).popAndPushNamed("/perfilview");
    }
  }

  void verificacionFallida(FirebaseAuthException excepcion){
    if (excepcion.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
  }

  void codigoEnviado(String codigo, int? resendToken) async{
    sVerificationCode=codigo;
    setState(() {
      blMostrarVerificacion=true;
    });


  }

  void tiempoDeEsperaAcabado(String verID){

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          CTextF(hint: "Numero Telefono",tController: tecPhone, password: false,),
          CButton(onPressed: enviarTelefonoPressed, text: "Enviar",),
          if(blMostrarVerificacion)
            CTextF(hint: "Numero Verificacion",tController: tecVerify,password: false,),
          if(blMostrarVerificacion)
            CButton(onPressed: enviarVerifyPressed, text: "Enviar",)
        ],

      ),

    );
  }
}