import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Modificar Perfil'),
            onTap: () {
              // Navegar a la vista del perfil
              Navigator.of(context).pushNamed('/profileeditview');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
            onTap: () {
              // Navegar a la vista de ajustes de notificaciones
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacidad'),
            onTap: () {
              // Navegar a la vista de ajustes de privacidad
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Idioma'),
            onTap: () {
              // Navegar a la vista de ajustes de idioma
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar sesión'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/loginview');
            },
          ),
        ],
      ),
    );
  }
}
