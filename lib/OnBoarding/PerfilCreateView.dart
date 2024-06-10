import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_psp_pmdm/Custom/BottomMenu.dart';
import 'package:proyecto_psp_pmdm/Custom/CButton.dart';
import 'package:proyecto_psp_pmdm/Custom/CTextF.dart';
import 'package:proyecto_psp_pmdm/Singletone/FirebaseAdmin.dart';
import '../FirestoreObjects/FbUsuario.dart';
import '../Singletone/DataHolder.dart';

class PerfilCreateView extends StatefulWidget {
  @override
  State<PerfilCreateView> createState() => _PerfilCreateViewState();
}

class _PerfilCreateViewState extends State<PerfilCreateView> {
  TextEditingController tecNombre = TextEditingController();
  TextEditingController tecEdad = TextEditingController();
  TextEditingController tecTalla = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAdmin fbAdmin = FirebaseAdmin();
  late BuildContext _context;
  ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  void onClickAceptar() async {
    Position currentPosition = await DataHolder().geolocAdmin.determinePosition();
    GeoPoint currentGeoPoint = GeoPoint(currentPosition.latitude, currentPosition.longitude);

    // Subir imagen a Firebase Storage
    String? imageUrl;
    if (_pickedImage != null) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child(fileName);

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageReference.putData(webImage);
      } else {
        uploadTask = storageReference.putFile(_pickedImage!);
      }

      TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() => null);
      imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    }

    FbUsuario usuario = FbUsuario(
      nombre: tecNombre.text,
      edad: int.parse(tecEdad.text),
      talla: double.parse(tecTalla.text),
      geoloc: currentGeoPoint,
      urlImg: imageUrl ?? '', // Proporcionar un valor por defecto si imageUrl es nulo
    );

    fbAdmin.agregarPerfilUsuario(usuario);
    print("Esto ha Funcionado");

    Navigator.of(_context).popAndPushNamed("/drawerview");
  }

  void onClickCancelar() {
    Navigator.of(_context).pop();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a'); // Dummy file
        });
      } else {
        setState(() {
          _pickedImage = File(image.path);
        });
      }
    } else {
      print('No image has been picked');
    }
  }

  void onCameraClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Perfil'),
        centerTitle: true,
        shadowColor: Colors.pink,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: !kIsWeb ? 20 : 200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CTextF(hint: "Nombre", tController: tecNombre, password: false),
                  CTextF(hint: "Edad", tController: tecEdad, password: false),
                  CTextF(hint: "Talla", tController: tecTalla, password: false),
                  _pickedImage != null
                      ? kIsWeb
                      ? Image.memory(webImage, width: 200, height: 200)
                      : Image.file(File(_pickedImage!.path), width: 200, height: 200)
                      : Icon(
                    Icons.photo,
                    size: 200,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CButton(text: "Galeria", onPressed: _pickImage),
                      if (!kIsWeb) CButton(text: "Camara", onPressed: onCameraClicked),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CButton(text: "Aceptar", onPressed: onClickAceptar),
                      //CButton(text: "Cancelar", onPressed: onClickCancelar),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
