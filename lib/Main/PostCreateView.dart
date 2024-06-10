import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../Custom/BottomMenu.dart';
import '../Custom/CButton.dart';
import '../Custom/CTextF.dart';
import '../FirestoreObjects/FbPost.dart';
import '../SingleTone/DataHolder.dart';

class PostCreateView extends StatefulWidget {
  @override
  State<PostCreateView> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  TextEditingController tcTitulo = TextEditingController();
  TextEditingController tcCuerpo = TextEditingController();
  TextEditingController tcTalla = TextEditingController();
  TextEditingController tcMarca = TextEditingController();
  TextEditingController tcColor = TextEditingController();
  TextEditingController tcPrecio = TextEditingController();
  TextEditingController tcTelefono = TextEditingController();

  ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  void onGalleryClicked() async {
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
    }
  }

  void onBottonMenuPressed(int indice) {
    print("------>>>> HOME!!!!!!" + indice.toString() + "---->>> ");
    setState(() {
      if (indice == 0) {
        Navigator.of(context).popAndPushNamed("/drawerview");
      } else if (indice == 1) {
        Navigator.of(context).pushNamed('/postcreateview');
      } else if (indice == 2) {
        Navigator.of(context).pushNamed('/wishlist');
      } else if (indice == 3) {
        Navigator.of(context).pushNamed('/perfilview');
      }
    });
  }

  void onCameraClicked() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  void subirPost() async {
    // Validaciones
    if (tcTalla.text.isEmpty || int.tryParse(tcTalla.text) == null || tcTalla.text.length > 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa una talla válida de hasta 2 dígitos.')),
      );
      return;
    }
    if (tcPrecio.text.isEmpty || int.tryParse(tcPrecio.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un precio válido.')),
      );
      return;
    }
    if (tcTelefono.text.isEmpty || !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(tcTelefono.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa un número de teléfono válido.')),
      );
      return;
    }

    final storageRef = FirebaseStorage.instance.ref();

    String rutaEnNube =
        "posts/" + FirebaseAuth.instance.currentUser!.uid + "/imgs/" +
            DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";

    final rutaAFicheroEnNube = storageRef.child(rutaEnNube);

    final metadata = SettableMetadata(contentType: "image/jpeg");
    try {
      if (_pickedImage != null) {
        if (kIsWeb) {
          await rutaAFicheroEnNube.putData(webImage, metadata);
        } else {
          await rutaAFicheroEnNube.putFile(_pickedImage!, metadata);
        }
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    String imgUrl = await rutaAFicheroEnNube.getDownloadURL();

    DocumentReference postRef = await FirebaseFirestore.instance.collection("ColeccionZapatillas").doc(FirebaseAuth.instance.currentUser!.uid).collection("ZapatillasStock").add({});

    FbPost postNuevo = FbPost(
        id: postRef.id,
        titulo: tcTitulo.text,
        cuerpo: tcCuerpo.text,
        sUrlImg: imgUrl,
        talla: int.parse(tcTalla.text),
        marca: tcMarca.text,
        color: tcColor.text,
        precio: int.parse(tcPrecio.text),
        isFavorite: false,
        telefono: tcTelefono.text);
    await postRef.set(postNuevo.toFirestore());

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popAndPushNamed("/drawerview");
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sube Tus Zapatillas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.only(left: !kIsWeb ? 20 : 200, right: !kIsWeb ? 20 : 200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(hint: "Titulo del Anuncio", tController: tcTitulo, password: false),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(hint: "Descripcion del Anuncio", tController: tcCuerpo, password: false),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(
                      hint: "Talla",
                      tController: tcTalla,
                      password: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(hint: "Marca", tController: tcMarca, password: false),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(hint: "Color", tController: tcColor, password: false),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(
                      hint: "Precio",
                      tController: tcPrecio,
                      password: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: CTextF(
                      hint: "Número de Teléfono",
                      tController: tcTelefono,
                      password: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                    ),
                  ),
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
                  SizedBox(height: 20),
                  CButton(text: "Subir", onPressed: subirPost),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(onBotonesClicked: this.onBottonMenuPressed),
    );
  }
}
