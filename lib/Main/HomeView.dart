import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'), // Título del AppBar
      ),
      body: Center(
        child: Text('Contenido de la pantalla principal'), // Contenido de la pantalla principal
      ),
    );
  }
}
