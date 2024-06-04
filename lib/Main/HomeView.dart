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
import '../FirestoreObjects/FbPost.dart';
import '../Singletone/DataHolder.dart';
import '../Singletone/FirebaseAdmin.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<FbPost> posts = [];
  List<FbPost> filteredPosts = [];
  final Map<String, FbPost> mapPosts = Map();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchController = TextEditingController();

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
    super.initState();
    FirebaseAdmin().descargarPosts();
    if (!kIsWeb) {
      DataHolder().suscribeACambiosGPSUsuario();
    }
    setearList();
    searchController.addListener(_filterPosts);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> setearList() async {
    try {
      List<FbPost> anunciosDescargadas = await DataHolder().fbadmin.descargarPosts();
      setState(() {
        posts = anunciosDescargadas;
        filteredPosts = posts; // Inicialmente, mostrar todos los posts
      });

      print("Número de anuncios descargados: ${posts.length}");
    } catch (e) {
      print("Error al descargar anuncios: $e");
    }
  }

  void _filterPosts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts.where((post) {
          return post.titulo.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _sortPostsByPrice(bool ascending) {
    setState(() {
      filteredPosts.sort((a, b) => ascending ? a.precio.compareTo(b.precio) : b.precio.compareTo(a.precio));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => ZoomDrawer.of(context)!.toggle(),
          icon: const Icon(Icons.menu),
        ),
        backgroundColor: Colors.blueAccent,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the search bar
            borderRadius: BorderRadius.circular(30), // Border radius
          ),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              icon: Icon(Icons.search, size: 25),
              hintText: 'Buscar...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: kIsWeb ? -5 : -10, vertical: kIsWeb ? 15 : 10),
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(color: Colors.black, fontSize: 18), // Text color
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'price_asc') {
                _sortPostsByPrice(true);
              } else if (result == 'price_desc') {
                _sortPostsByPrice(false);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'price_asc',
                child: Text('Precio: Menor a Mayor'),
              ),
              const PopupMenuItem<String>(
                value: 'price_desc',
                child: Text('Precio: Mayor a Menor'),
              ),
            ],
            icon: Icon(Icons.filter_list,size: 30),
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: celdas(), // Contenido de la pantalla principal
      ),
      bottomNavigationBar: BottomMenu(onBotonesClicked: this.onBottonMenuPressed),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/postcreateview");
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  void onItemListClicked(int index) {
    DataHolder().selectedPost = filteredPosts[index];
    DataHolder().saveSelectedPostInCache();
    Navigator.of(context).pushNamed("/postview");
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index) {
    return PostGridCellView(
      sText: filteredPosts[index].titulo,
      datosPost: filteredPosts[index],
      precio: filteredPosts[index].precio,
      sUrlImg: filteredPosts[index].sUrlImg,
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
        crossAxisCount: !kIsWeb ? 1 : 4,
        mainAxisExtent: !kIsWeb ? 400 : 461,
      ),
      itemCount: filteredPosts.length,
      scrollDirection: Axis.vertical,
      itemBuilder: creadorDeItemMatriz,
    );
  }
}
