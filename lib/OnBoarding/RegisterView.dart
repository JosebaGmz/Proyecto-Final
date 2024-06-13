import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Custom/CButton.dart';
import '../Custom/CTextF.dart';
import '../Custom/Colors.dart';
import '../Custom/Sizes.dart';

class RegisterView extends StatelessWidget{

  late BuildContext _context;

  TextEditingController tUsername=TextEditingController();
  TextEditingController tPassword=TextEditingController();
  TextEditingController tRespass=TextEditingController();

  SnackBar snackBar = SnackBar(
    content: Text('Asegurate de tener todos los campos rellenos'),
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
    _context = context;

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
                    Text("Registrarse",
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
                            controller: tUsername,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.arrow_right_alt_rounded),
                                labelText: "E-Mail"),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          TextFormField(
                            controller: tPassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.password),
                                labelText: "Contraseña",
                                ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputFields),
                          TextFormField(
                            controller: tRespass,
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.password),
                                labelText: "Repita su contraseña",
                                ),
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
                                      "")),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: onClickAceptar, child: Text(
                                  "Registrarse"))),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: onClickCancelar, child: Text(
                                  "Cancelar"))),
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
                          Text("Registrarse",
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
                                    controller: tUsername,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(
                                            Icons.arrow_right_alt_rounded),
                                        labelText: "E-Mail"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: TSizes.spaceBtwInputFields),
                                  child: TextFormField(
                                    controller: tPassword,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(Icons.password),
                                        labelText: "Contraseña",
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: TSizes.spaceBtwInputFields),
                                  child: TextFormField(
                                    controller: tRespass,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(Icons.password),
                                        labelText: "Repita su contraseña",
                                        ),
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
                                            "")),
                                  ],
                                ),
                                const SizedBox(height: TSizes.spaceBtwSections),
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: TSizes.defaultSpace / 2),
                                      child: ElevatedButton(
                                          onPressed: onClickAceptar,
                                          child: Text("Registrarse")),
                                    )),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: TSizes.defaultSpace / 2),
                                      child: OutlinedButton(
                                          onPressed: onClickCancelar,
                                          child: Text("Cancelar")),
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