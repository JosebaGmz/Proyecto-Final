import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Custom/CButton.dart';
import '../Custom/CTextF.dart';
import '../FirestoreObjects/FbPost.dart';
import '../SingleTone/DataHolder.dart';
import 'package:universal_html/html.dart' as html;

class PostCreateView extends StatefulWidget{

  @override
  State<PostCreateView> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  TextEditingController tcTitulo=TextEditingController();

  TextEditingController tcCuerpo=TextEditingController();
  TextEditingController tcTalla=TextEditingController();
  TextEditingController tcMarca=TextEditingController();
  TextEditingController tcColor=TextEditingController();
  TextEditingController tcPrecio=TextEditingController();

  ImagePicker _picker=ImagePicker();
  File _pickedImage = File("");
  Uint8List webImage = Uint8List(8);

  void onGalleryClicked() async{
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        _pickedImage=File(image.path);
      });
    }
  }

  void onCameraClicked() async{
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image!=null){
      setState(() {
        _pickedImage=File(image.path);
      });
    }
  }

  void subirPost() async {

    final storageRef = FirebaseStorage.instance.ref();

    String rutaEnNube=
        "posts/"+FirebaseAuth.instance.currentUser!.uid+"/imgs/"+
            DateTime.now().millisecondsSinceEpoch.toString()+".jpg";

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

    }
    String imgUrl=await rutaAFicheroEnNube.getDownloadURL();


    FbPost postNuevo=new FbPost(
        titulo: tcTitulo.text,
        cuerpo: tcCuerpo.text,
        sUrlImg: imgUrl,
        talla: int.parse(tcTalla.text) ,
        marca: tcMarca.text,
        color: tcColor.text,
        precio:int.parse(tcPrecio.text));
    DataHolder().insertPostEnFB(postNuevo);

    Navigator.of(context).popAndPushNamed("/drawerview");
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Sube Tus Zapatillas"),backgroundColor: Colors.blueGrey,centerTitle: true,),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Titulo del Anuncio",tController:tcTitulo,password: false),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Descripcion del Anuncio",tController: tcCuerpo,password: false),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Talla",tController: tcTalla,password: false),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Marca",tController: tcMarca,password: false),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Color",tController: tcColor,password: false),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: CTextF(hint: "Precio",tController: tcPrecio,password: false),
          ),
          //Image.file(_imagePreview,width: 200,height: 200,),
           //_pickedImage != null
              kIsWeb
              ? Image.memory(webImage, width: 200, height: 200)
              : Image.file(_pickedImage,width: 200,height:200 ,),
          Row(
            children: [
              CButton( text: "Galeria",onPressed: _pickImage),
              if(!kIsWeb) CButton(text: "Camara",onPressed: onCameraClicked),
            ],
          ),
          CButton(text: "Subir",onPressed: subirPost)
        ],
      ),
      ),
    );
  }
}