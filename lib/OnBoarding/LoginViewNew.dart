import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/Colors.dart';
import 'package:proyecto_psp_pmdm/Custom/Sizes.dart';

class LoginViewNew extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BuildContext _context;
  TextEditingController tUsername = TextEditingController();
  TextEditingController tPassword = TextEditingController();

  void onClickRegistrar(){
    Navigator.of(_context).pushNamed("/registerview");
  }

  void onClickAceptar() async {

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: tUsername.text,
          password: tPassword.text
      );

      print("----LOGEADO----");

      String uid=FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> datos=await db.collection("Usuarios").doc(uid).get();
      if(datos.exists){
        Navigator.of(_context).popAndPushNamed("/drawerview");
      }
      else{
        Navigator.of(_context).popAndPushNamed("/perfilcreateview");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    ///MOVIL
    if(!kIsWeb){
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
                    Text("Iniciar Sesion,",
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: TSizes.sm),
                    Text(
                        "Bienvenido a mi aplicacion de reventa de zapatillas esperemos que disfrute de su uso.",
                        style: Theme.of(context).textTheme.bodyMedium),
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
                                labelText: "Password",
                                suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputFields / 2),
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
                                  child: const Text("Olvidaste tu Contraseña?")),
                            ],
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: onClickAceptar, child: Text("Iniciar Sesion"))),
                          const SizedBox(height: TSizes.spaceBtwItems),
                          SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: onClickRegistrar, child: Text("Crear Cuenta"))),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Divider(color: TColors.grey,thickness: 0.5,indent: 60,endIndent: 5)),
                    Text("O inicia sesion con",style: Theme.of(context).textTheme.labelMedium,),
                    Flexible(child: Divider(color: TColors.grey,thickness: 0.5,indent: 5,endIndent: 60)),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: TColors.grey),borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: (){},
                        icon: const Image(
                          width: TSizes.iconMd,
                          height: TSizes.iconMd,
                          image: NetworkImage("https://www.imagensempng.com.br/wp-content/uploads/2023/05/278-4.png"),

                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    else
    {
      ///WEB
      return Scaffold(
        backgroundColor: Color.fromRGBO(41, 54, 61,0.8), // Color de fondo alrededor
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
                  color: Colors.white, // Color de fondo blanco para el contenido centrado
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],// Bordes redondeados
                ),
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600), // Set a maximum width
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
                          Text("Iniciar Sesion,",
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: TSizes.sm),
                          Text(
                              "Bienvenido a mi aplicacion de reventa de zapatillas esperemos que disfrute de su uso.",
                              style: Theme.of(context).textTheme.bodyMedium),
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
                                  padding: const EdgeInsets.only(bottom: TSizes.spaceBtwInputFields),
                                  child: TextFormField(
                                    controller: tUsername,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(Icons.arrow_right_alt_rounded),
                                        labelText: "E-Mail"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: TSizes.spaceBtwInputFields),
                                  child: TextFormField(
                                    controller: tPassword,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        prefixIcon: Icon(Icons.password),
                                        labelText: "Password",
                                        suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                                  ),
                                ),
                                const SizedBox(height: TSizes.spaceBtwInputFields / 2),
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
                                        child: const Text("Olvidaste tu Contraseña?")),
                                  ],
                                ),
                                const SizedBox(height: TSizes.spaceBtwSections),
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace / 2),
                                      child: ElevatedButton(
                                          onPressed: onClickAceptar,
                                          child: Text("Iniciar Sesion")),
                                    )),
                                const SizedBox(height: TSizes.spaceBtwItems),
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace / 2),
                                      child: OutlinedButton(
                                          onPressed: onClickRegistrar,
                                          child: Text("Crear Cuenta")),
                                    )),
                              ],
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Divider(
                                  color: TColors.grey,
                                  thickness: 0.5,
                                  indent: 60,
                                  endIndent: 5)),
                          Text(
                            "O inicia sesion con",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Flexible(
                              child: Divider(
                                  color: TColors.grey,
                                  thickness: 0.5,
                                  indent: 5,
                                  endIndent: 60)),
                        ],
                      ),
                      const SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: TColors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Image(
                                width: TSizes.iconMd,
                                height: TSizes.iconMd,
                                image: NetworkImage(
                                    "https://www.imagensempng.com.br/wp-content/uploads/2023/05/278-4.png"),
                              ),
                            ),
                          )
                        ],
                      )
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
