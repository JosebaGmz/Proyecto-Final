
import 'package:flutter/material.dart';
import '../FirestoreObjects/FbPost.dart';
import '../Singletone/DataHolder.dart';

class PostView extends StatefulWidget{
  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  FbPost _datosPost = FbPost(cuerpo: "NAN",sUrlImg: "NAN",titulo: "NAN", talla: 0, marca: 'NAN', color: 'NAN', precio: 0);
  bool blPostLoaded=false;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    cargarPostGuardadoEnCache();
  }

  void cargarPostGuardadoEnCache() async{
    var temp1=await DataHolder().loadFbPost();
    //print("----------->>>>> "+temp1!.titulo);
    setState(() {

      _datosPost=temp1!;
      blPostLoaded=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(title: Text(DataHolder().sNombre),centerTitle: true,),
      body: Center(
        child: blPostLoaded ? Column(
          children: [
            Text(_datosPost.titulo),
            Text(_datosPost.cuerpo),
            Text(_datosPost.talla.toString()),
            Text(_datosPost.marca),
            Image.network(_datosPost.sUrlImg,width: 200,height: 200,),
            TextButton(onPressed: null, child: Text("Like"))
          ],
        )
            :
        CircularProgressIndicator(),
      )
    );

  }
}