import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:proyecto_psp_pmdm/Custom/DrawerClass.dart';

import '../Custom/BottomMenu.dart';
import '../Custom/PostCellView.dart';
import '../Custom/PostGridCellView.dart';
import '../Custom/PostGridNewView.dart';
import '../FirestoreObjects/FbPost.dart';
import '../FirestoreObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';
import '../Singletone/FirebaseAdmin.dart';

class PerfilView extends StatefulWidget {
  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<FbPost> posts = [];
  final Map<String,FbPost> mapPosts = Map();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String? userName = '';
  String? userPhotoUrl = '';
  int anunciosCount = 0;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdmin().descargarPostsUnicos();
    _loadUserName();
    _getAnunciosCount();
    if(!kIsWeb){
      DataHolder().suscribeACambiosGPSUsuario();
    }
    setearList();
  }

  Future<void> _getAnunciosCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('ColeccionZapatillas')
          .doc(user.uid)
          .collection('ZapatillasStock')
          .get();

      setState(() {
        anunciosCount = snapshot.size;
      });
    }
  }

  void _loadUserName() async {
    String? name = await getUserName();
    setState(() {
      userName = name;
    });
  }

  Future<String?> getUserName() async {
    String? userName;

    try {
      // Obtén el ID del usuario actualmente logueado
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Accede al documento del usuario en Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();

      // Convierte el documento en un objeto FbUsuario
      FbUsuario user = FbUsuario.fromFirestore(userSnapshot, null);

      // Obtén el nombre y la URL de la imagen del usuario del objeto FbUsuario
      userName = user.nombre;
      userPhotoUrl = user.urlImg;
    } catch (e) {
      // Manejar cualquier error
      print('Error al obtener el nombre del usuario: $e');
    }

    return userName;
  }

  Future<void> setearList() async {
    try {
      List<FbPost> anunciosDescargadas = await DataHolder().fbadmin.descargarPostsUnicos();
      setState(() {
        posts = anunciosDescargadas;
      });

      print("Número de anuncios descargados: ${posts.length}");
    } catch (e) {
      print("Error al descargar anuncios: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).popAndPushNamed("/drawerview"),
            icon: const Icon(Icons.arrow_back)
        ),
        backgroundColor: Colors.blueAccent,
        title: Text('Mi Perfil', style: TextStyle(color: Colors.white)), // Título del AppBar
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.grey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(userPhotoUrl ?? 'https://via.placeholder.com/150'), // URL de la foto de perfil
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 16.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName!,
                      style: TextStyle(fontSize: kIsWeb ? 24 : 16, color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Anuncios',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      anunciosCount.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: celdas(), // Contenido de la pantalla principal
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomMenu(
          onBotonesClicked: this.onBottonMenuPressed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  void onItemListClicked(int index){
    DataHolder().selectedPost = posts[index];
    DataHolder().saveSelectedPostInCache();
    Navigator.of(context).pushNamed("/postview");
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index){
    return PostGridNewView(sText: posts[index].titulo,
        datosPost: posts[index],
        precio: posts[index].precio,
        sUrlImg: posts[index].sUrlImg,
        dFontSize: 28,
        iColorCode: 0,
        dHeight: DataHolder().platformAdmin.getScreenHeight() * 0.5,
        iPosicion: index,
        onItemListClickedFun: onItemListClicked
    );
  }

  Widget celdas() {
    return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: !kIsWeb ? 1 : 4,
          mainAxisExtent: !kIsWeb ? 400 : 461,),
        itemCount: posts.length,
        scrollDirection: Axis.vertical,
        itemBuilder: creadorDeItemMatriz
    );
  }
}
