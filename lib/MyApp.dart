import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/DrawerClass.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';
import 'package:proyecto_psp_pmdm/Main/PostCreateView.dart';
import 'package:proyecto_psp_pmdm/Main/PostView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/LoginView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/PerfilView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/RegisterView.dart';
import 'package:proyecto_psp_pmdm/Singletone/DataHolder.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    DataHolder().initPlatformAdmin(context);
    MaterialApp materialApp;

    materialApp = MaterialApp(title: "SNKRS APP",
    routes: {
      '/loginview':(context) => LoginView(),
      '/registerview':(context) => RegisterView(),
      '/perfilview':(context) => PerfilView(),
      '/homeview':(context) => HomeView(),
      '/drawerview':(context) => DrawerClass(),
      '/postview':(context) => PostView(),
      '/postcreateview':(context) => PostCreateView(),
    },
      initialRoute: '/loginview',
      debugShowCheckedModeBanner: false,
    );
    return materialApp;
  }

}