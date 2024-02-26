import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:proyecto_psp_pmdm/Custom/DrawerClass.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: const Icon(Icons.menu)
        ),
        title: Text('Mi Aplicación'), // Título del AppBar
      ),
      body: Center(
        child: Text('Contenido de la pantalla principal'), // Contenido de la pantalla principal
      ),
    );
  }
}
