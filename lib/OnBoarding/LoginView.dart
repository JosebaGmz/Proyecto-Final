import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatelessWidget{
  FirebaseFirestore db = FirebaseFirestore.instance;
  late BuildContext _context;

  void onClickRegistrar(){
    Navigator.of(_context).pushNamed("/registerview");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}