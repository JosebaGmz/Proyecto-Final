import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  String? _photoURL;
  File? _imageFile;
  Uint8List? _webImage;

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
        _photoURL = userDoc.data()?['urlImg']; // Cargar la URL de la foto de perfil
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      String uid = _currentUser!.uid;
      String? photoURL = _photoURL;

      if (_imageFile != null || _webImage != null) {
        photoURL = await _uploadProfileImage();
      }

      await _firestore.collection('Usuarios').doc(uid).update({
        'nombre': _nameController.text,
        'edad': int.parse(_ageController.text),
        'talla': double.parse(_sizeController.text),
        'urlImg': photoURL,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Perfil actualizado')));
    }
  }

  Future<String> _uploadProfileImage() async {
    String fileName = 'profile_${_currentUser!.uid}.png';
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child(fileName);

    if (kIsWeb) {
      UploadTask uploadTask = storageRef.putData(_webImage!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } else {
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
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
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : _webImage != null
                    ? MemoryImage(_webImage!)
                    : _photoURL != null
                    ? NetworkImage(_photoURL!) as ImageProvider
                    : NetworkImage("https://previews.123rf.com/images/yupiramos/yupiramos1705/yupiramos170514531/77987158-dise%C3%B1o-gr%C3%A1fico-del-ejemplo-del-vector-del-icono-del-perfil-del-hombre-joven.jpg"),
                child: Icon(Icons.edit),
              ),
            ),
            SizedBox(height: 20),
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
