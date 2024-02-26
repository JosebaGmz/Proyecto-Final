import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';

class DrawerClass extends StatefulWidget {
  const DrawerClass({Key? key}) : super(key: key);

  @override
  _DrawerClassState createState() => _DrawerClassState();
}

class _DrawerClassState extends State<DrawerClass> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      style: DrawerStyle.Style1,
      menuScreen: const MENU_SCREEN(),
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
  const MENU_SCREEN({Key? key}) : super(key: key);

  @override
  _MENU_SCREENState createState() => _MENU_SCREENState();
}

class _MENU_SCREENState extends State<MENU_SCREEN> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //color: Colors.indigo,
      width: 2560,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(

              color: Colors.indigo,
            ),
            child: Text(
                style: TextStyle(color: Colors.white),
                'Header'
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings,color: Colors.black,),
            selectedColor: Colors.blue,
            selected: true,
            title: const Text('Apartado 1'),

          ),
          ListTile(
            leading: Icon(Icons.accessible_forward_rounded, color: Colors.red),
            title: const Text('Apartado 2'),
          ),
          ListTile(
            leading: Icon(Icons.location_city, color: Colors.black),
            title: const Text('AQUI UBICACION'),
          ),
        ],
      ),
    );
  }
}