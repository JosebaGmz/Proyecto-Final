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

class PerfilView extends StatefulWidget{
  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<FbPost> posts = [];
  final Map<String,FbPost> mapPosts = Map();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool bIsList=false;

  void onBottonMenuPressed(int indice) {
    // TODO: implement onBottonMenuPressed
    print("------>>>> HOME!!!!!!"+indice.toString()+"---->>> ");
    setState(() {
      if(indice == 0){
        bIsList=true;
      }
      else if(indice==1){
        bIsList=false;
      }
      else if(indice==2){
        exit(0);
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAdmin().descargarPostsUnicos();
    if(!kIsWeb){
      DataHolder().suscribeACambiosGPSUsuario();
    }
    setearList();
  }

  Future<void> setearList()async{
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
        title: Text('Mi Perfil'), // Título del AppBar
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: celdasOLista(bIsList), // Contenido de la pantalla principal
      ),
      bottomNavigationBar: BottomMenu(
          onBotonesClicked: this.onBottonMenuPressed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }

  void onItemListClicked(int index){
    DataHolder().selectedPost=posts[index];
    DataHolder().saveSelectedPostInCache();
    Navigator.of(context).pushNamed("/postview");
  }

  Widget? creadorDeItemLista(BuildContext context, int index){
    return PostCellView(sText: posts[index].titulo,
        sUrlImg: posts[index].sUrlImg,
        dFontSize: 30,
        iColorCode: 0,
        iPosicion: index,
        onItemListClickedFun:onItemListClicked
    );
  }

  Widget? creadorDeItemMatriz(BuildContext context, int index){
    return PostGridCellView(sText: posts[index].titulo,
        datosPost: posts[index],
        precio: posts[index].precio,
        sUrlImg: posts[index].sUrlImg,
        dFontSize: 28,
        iColorCode: 0,
        dHeight: DataHolder().platformAdmin.getScreenHeight()*0.5,
        iPosicion: index,
        onItemListClickedFun:onItemListClicked
    );
  }

  Widget creadorDeSeparadorLista(BuildContext context, int index) {
    //return Divider(thickness: 5,);
    return Column(
      children: [
        Divider(),
        //CircularProgressIndicator(),
        //Image.network("https://media.tenor.com/zBc1XhcbTSoAAAAC/nyan-cat-rainbow.gif")
      ],
    );
  }

  Widget celdasOLista(bool isList) {
    if (isList) {
      return ListView.separated(
        padding: EdgeInsets.all(8),
        itemCount: posts.length,
        itemBuilder: creadorDeItemLista,
        separatorBuilder: creadorDeSeparadorLista,
      );
    } else {
      return
        GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 400,),
            itemCount: posts.length,
            scrollDirection: Axis.vertical,
            itemBuilder: creadorDeItemMatriz
        );
    }
  }
}