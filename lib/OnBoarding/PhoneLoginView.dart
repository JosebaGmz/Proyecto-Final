import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proyecto_psp_pmdm/Custom/CButton.dart';
import 'package:proyecto_psp_pmdm/Custom/CTextF.dart';

import '../Custom/Colors.dart';
import '../Custom/Sizes.dart';
import '../FirestoreObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class PhoneLoginView extends StatefulWidget{
  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {

  TextEditingController tecPhone = TextEditingController();
  TextEditingController tecVerify = TextEditingController();
  String sVerificationCode = "";
  bool blMostrarVerificacion = false;


  void enviarTelefonoPressed() async {
    String sTelefono = tecPhone.text;

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: sTelefono,
        verificationCompleted: verificacionCompletada,
        verificationFailed: verificacionFallida,
        codeSent: codigoEnviado,
        codeAutoRetrievalTimeout: tiempoDeEsperaAcabado);
  }

  void enviarVerifyPressed() async {
    String smsCode = tecVerify.text;

    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(
        verificationId: sVerificationCode, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance.signInWithCredential(credential);

    FbUsuario? usuario = await DataHolder().loadFbUsuario();
    Position pos = await DataHolder().geolocAdmin.determinePosition();
    //print("----------->>>>>>>>>>>>>>>>>>> "+pos.toString());
    DataHolder().suscribeACambiosGPSUsuario();

    if (usuario != null) {
      print("EL NOMBRE DEL USUARIO LOGEADO ES: " + usuario.nombre);
      print("LA EDAD DEL USUARIO LOGEADO ES: " + usuario.edad.toString());
      Navigator.of(context).popAndPushNamed("/drawerview");
    }
    else {
      Navigator.of(context).popAndPushNamed("/perfilcreateview");
    }
  }

  void verificacionCompletada(PhoneAuthCredential credencial) async {
    await FirebaseAuth.instance.signInWithCredential(credencial);

    FbUsuario? usuario = await DataHolder().loadFbUsuario();
    Position pos = await DataHolder().geolocAdmin.determinePosition();
    //print("----------->>>>>>>>>>>>>>>>>>> "+pos.toString());
    DataHolder().suscribeACambiosGPSUsuario();

    if (usuario != null) {
      print("EL NOMBRE DEL USUARIO LOGEADO ES: " + usuario.nombre);
      print("LA EDAD DEL USUARIO LOGEADO ES: " + usuario.edad.toString());
      Navigator.of(context).popAndPushNamed("/drawerview");
    }
    else {
      Navigator.of(context).popAndPushNamed("/perfilcreateview");
    }
  }

  void verificacionFallida(FirebaseAuthException excepcion) {
    if (excepcion.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }
  }

  void codigoEnviado(String codigo, int? resendToken) async {
    sVerificationCode = codigo;
    setState(() {
      blMostrarVerificacion = true;
    });
  }

  void tiempoDeEsperaAcabado(String verID) {

  }

  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar Sesion",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CTextF(hint: "Numero Telefono",tController: tecPhone, password: false,),
            CButton(onPressed: enviarTelefonoPressed, text: "Enviar",),
            if(blMostrarVerificacion)
              CTextF(hint: "Numero Verificacion",tController: tecVerify,password: false,),
            if(blMostrarVerificacion)
              CButton(onPressed: enviarVerifyPressed, text: "Enviar",)
          ],

        ),
      ),

    );
  }*/

  @override
  Widget build(BuildContext context) {


    ///MOVIL
    if (!kIsWeb) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: TSizes.appBarHeight,
              left: TSizes.defaultSpace,
              bottom: TSizes.defaultSpace,
              right: TSizes.defaultSpace,
            ),
            child: Column(
              children: [

                ///Logo, titulo y subtitulo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: 150,
                      image: NetworkImage(
                          "https://i.pinimg.com/originals/2e/88/36/2e88365a6db490d968273793773f2ae7.jpg"),
                    ),
                    Text("Iniciar Sesion",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium),
                    const SizedBox(height: TSizes.sm),
                    Text(
                        "Bienvenido a mi aplicacion de reventa de zapatillas esperemos que disfrute de su uso.",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium),
                  ],
                ),

                ///Formulario
                Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: TSizes.spaceBtwSections),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: tecPhone,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.arrow_right_alt_rounded),
                                labelText: "Numero de telefono"),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          if(blMostrarVerificacion)
                            TextFormField(
                              controller: tecVerify,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.password),
                                  labelText: "Numero verificacion",
                                  suffixIcon: Icon(
                                      Icons.remove_red_eye_outlined)),
                            ),
                          const SizedBox(
                              height: TSizes.spaceBtwInputFields / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(""),
                                ],
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                      "Olvidaste tu Contraseña?")),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: enviarTelefonoPressed, child: Text(
                                  "Comprobar Telefono"))),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          if(blMostrarVerificacion)
                            SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: TSizes.defaultSpace / 2),
                                  child: OutlinedButton(
                                      onPressed: enviarVerifyPressed,
                                      child: Text("Iniciar Sesion")),
                                )),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    }
    else {
      ///WEB
      return Scaffold(
        backgroundColor: Color.fromRGBO(41, 54, 61, 0.8),
        // Color de fondo alrededor
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                bottom: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // Color de fondo blanco para el contenido centrado
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ], // Bordes redondeados
                ),
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  // Set a maximum width
                  child: Column(
                    children: [

                      ///Logo, titulo y subtitulo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            height: 150,
                            image: NetworkImage(
                                "https://i.pinimg.com/originals/2e/88/36/2e88365a6db490d968273793773f2ae7.jpg"),
                          ),
                          Text("Iniciar Sesion",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineMedium),
                          const SizedBox(height: TSizes.sm),
                          Text(
                              "Bienvenido a mi aplicacion de reventa de zapatillas esperemos que disfrute de su uso.",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium),
                        ],
                      ),

                      ///Formulario
                      Form(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: TSizes.spaceBtwSections),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: TSizes.spaceBtwInputFields),
                                  child: TextFormField(
                                    controller: tecPhone,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(
                                            Icons.arrow_right_alt_rounded),
                                        labelText: "Numero de telefono"),
                                  ),
                                ),
                                if(blMostrarVerificacion)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: TSizes.spaceBtwInputFields),
                                    child: TextFormField(
                                      controller: tecVerify,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          prefixIcon: Icon(Icons.password),
                                          labelText: "Numero de verificacion",
                                          suffixIcon: Icon(
                                              Icons.remove_red_eye_outlined)),
                                    ),
                                  ),
                                const SizedBox(
                                    height: TSizes.spaceBtwInputFields / 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(""),
                                      ],
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                            "Olvidaste tu Contraseña?")),
                                  ],
                                ),
                                const SizedBox(height: TSizes.spaceBtwSections),
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: TSizes.defaultSpace / 2),
                                      child: ElevatedButton(
                                          onPressed: enviarTelefonoPressed,
                                          child: Text("Comprobar Telefono")),
                                    )),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                if(blMostrarVerificacion)
                                  SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: TSizes.defaultSpace / 2),
                                        child: OutlinedButton(
                                            onPressed: enviarVerifyPressed,
                                            child: Text("Iniciar Sesion")),
                                      )),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}