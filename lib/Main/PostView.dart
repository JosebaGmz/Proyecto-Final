import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Custom/BottomMenu.dart';
import '../Custom/LikeButton.dart';
import '../FirestoreObjects/FbPost.dart';
import '../Singletone/DataHolder.dart';

class PostView extends StatefulWidget {
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  FbPost _datosPost = FbPost(
      cuerpo: "NAN",
      sUrlImg: "NAN",
      titulo: "NAN",
      talla: 0,
      marca: 'NAN',
      color: 'NAN',
      precio: 0);
  bool blPostLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarPostGuardadoEnCache();
  }

  void cargarPostGuardadoEnCache() async {
    var temp1 = await DataHolder().loadFbPost();
    //print("----------->>>>> "+temp1!.titulo);
    setState(() {
      _datosPost = temp1!;
      blPostLoaded = true;
    });
  }

  void onBottonMenuPressed(int indice) {
    print("------>>>> HOME!!!!!!" + indice.toString() + "---->>> ");
    setState(() {
      if (indice == 0) {
        Navigator.of(context).popAndPushNamed("/drawerview");
      } else if (indice == 1) {
        // Handle other actions
      } else if (indice == 2) {
        Navigator.of(context).pushNamed('/wishlist');
      } else if (indice == 3) {
        Navigator.of(context).pushNamed('/perfilview');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> coleccionesRef = db.collection("ColeccionZapatillas");

    return Scaffold(
      appBar: AppBar(
        title: Text(DataHolder().sNombre,style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.grey[200], // Color de fondo
        child: Center(
          child: blPostLoaded
              ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          _datosPost.sUrlImg,
                          width: 500,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          _datosPost.titulo,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Marca: ${_datosPost.marca}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Talla: ${_datosPost.talla}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Color: ${_datosPost.color}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _datosPost.cuerpo,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Precio: \$${_datosPost.precio}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
              : CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: BottomMenu(onBotonesClicked: this.onBottonMenuPressed),
    );
  }
}
