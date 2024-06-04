import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Custom/BottomMenu.dart';
import '../Custom/PostGridCellView.dart';
import '../FirestoreObjects/FbPost.dart';
import '../Singletone/DataHolder.dart';
import '../Singletone/FirebaseAdmin.dart';

class WishlistView extends StatefulWidget {
  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<FbPost> posts = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;

  void onBottonMenuPressed(int indice) {
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
    super.initState();
    FirebaseAdmin().descargarPostsUnicos();
    if (!kIsWeb) {
      DataHolder().suscribeACambiosGPSUsuario();
    }
    setearList();
  }

  Future<void> setearList() async {
    try {
      List<FbPost> anunciosDescargadas = await FirebaseAdmin().descargarPostsFavoritos();
      setState(() {
        posts = anunciosDescargadas;
        print("Número de anuncios descargados: ${posts.length}");
      });
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
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.blueAccent,
        title: Text('Favoritos'), // Título del AppBar
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: celdas(), // Contenido de la pantalla principal
      ),
      bottomNavigationBar: BottomMenu(
          onBotonesClicked: this.onBottonMenuPressed),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  void onItemListClicked(int index) {
    DataHolder().selectedPost = posts[index];
    DataHolder().saveSelectedPostInCache();
    Navigator.of(context).pushNamed("/postview");
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index) {
    return PostGridCellView(
      sText: posts[index].titulo,
      datosPost: posts[index],
      precio: posts[index].precio,
      sUrlImg: posts[index].sUrlImg,
      dFontSize: 28,
      iColorCode: 0,
      dHeight: DataHolder().platformAdmin.getScreenHeight() * 0.5,
      iPosicion: index,
      onItemListClickedFun: onItemListClicked,
    );
  }

  Widget celdas() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !kIsWeb ? 2 : 4,
        mainAxisExtent: !kIsWeb ? 250 : 461,
      ),
      itemCount: posts.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: creadorDeItemMatriz,
    );
  }
}
