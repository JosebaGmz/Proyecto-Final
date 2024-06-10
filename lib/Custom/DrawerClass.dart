import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';
import 'package:proyecto_psp_pmdm/Main/PerfilView.dart';
import 'package:proyecto_psp_pmdm/SingleTone/DataHolder.dart';

import '../FirestoreObjects/FbUsuario.dart';

class DrawerClass extends StatefulWidget {
  const DrawerClass({Key? key}) : super(key: key);

  @override
  _DrawerClassState createState() => _DrawerClassState();

}

class _DrawerClassState extends State<DrawerClass> {

  void fHomeViewDrawerOnTap(int indice){
    print("---->>>> "+indice.toString());
    if(indice==0){

      Navigator.of(context).pushNamed('/settingsview');
    }
    else if(indice==1){
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      menuScreen: MENU_SCREEN(onItemTap: (int index) {
        fHomeViewDrawerOnTap(index);
      },),
      mainScreen: HomeView(),
      borderRadius: 40.0,
      showShadow: true,
      angle: -12.0,
      backgroundColor: Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * (kIsWeb? .20 : .65),
      openCurve: Curves.easeIn,
      closeCurve: Curves.easeInOut,
    );
  }
}

class MENU_SCREEN extends StatefulWidget {
  final Function(int indice)? onItemTap;

   const MENU_SCREEN({Key? key, this.onItemTap}) : super(key: key);

  @override
  _MENU_SCREENState createState() => _MENU_SCREENState();

}

class _MENU_SCREENState extends State<MENU_SCREEN> {

  String? userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
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

      // Obtén el nombre del usuario del objeto FbUsuario
      userName = user.nombre;
    } catch (e) {
      // Manejar cualquier error
      print('Error al obtener el nombre del usuario: $e');
    }

    return userName;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 2560,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            onTap: () {
              // Manejar el evento cuando se presiona el icono de la foto de perfil
              // Aquí puedes navegar a otra pantalla, abrir un diálogo, etc.
              // Por ejemplo, puedes abrir una pantalla de perfil:
              Navigator.of(context).pushNamed('/perfilview');
            },
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  // Icono de foto de perfil
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 48, // Tamaño del icono
                  ),
                  SizedBox(width: 16), // Espacio entre el icono y el texto
                  // Texto en el DrawerHeader
                  Text(
                    userName ?? 'cargando...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24, // Tamaño del texto
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            selectedColor: Colors.blue,
            selected: true,
            title: const Text('Ajustes'),
            onTap: () {
              widget.onItemTap!(0);
            },
          ),
        ],
      ),
    );
  }
}