import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../FirestoreObjects/FbUsuario.dart';

class ProfileEditView extends StatefulWidget {
  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('Usuarios').doc(_currentUser!.uid).get();
      FbUsuario user = FbUsuario.fromFirestore(userDoc, null);
      setState(() {
        _nameController.text = user.nombre ?? '';
        _ageController.text = user.edad.toString();
        _sizeController.text = user.talla.toString();
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      String uid = _currentUser!.uid;
      await _firestore.collection('Usuarios').doc(uid).update({
        'nombre': _nameController.text,
        'edad': int.parse(_ageController.text),
        'talla': double.parse(_sizeController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _sizeController,
              decoration: InputDecoration(labelText: 'Talla'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
