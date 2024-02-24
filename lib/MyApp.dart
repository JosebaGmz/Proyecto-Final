import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/LoginView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/PerfilView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/RegisterView.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    MaterialApp materialApp;

    materialApp = MaterialApp(title: "SNKRS APP",
    routes: {
      '/loginview':(context) => LoginView(),
      '/registerview':(context) => RegisterView(),
      '/perfilview':(context) => PerfilView(),
      '/homeview':(context) => HomeView(),
    },
      initialRoute: '/loginview',
      debugShowCheckedModeBanner: false,
    );
    return materialApp;
  }

}