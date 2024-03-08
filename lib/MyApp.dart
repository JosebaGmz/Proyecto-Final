import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/DrawerClass.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';
import 'package:proyecto_psp_pmdm/Main/MapaView.dart';
import 'package:proyecto_psp_pmdm/Main/PostCreateView.dart';
import 'package:proyecto_psp_pmdm/Main/PostView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/LoginView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/PerfilCreateView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/RegisterView.dart';
import 'package:proyecto_psp_pmdm/Singletone/DataHolder.dart';
import 'package:proyecto_psp_pmdm/Splash/SplashView.dart';

import 'Main/PerfilView.dart';
import 'OnBoarding/PhoneLoginView.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    DataHolder().initPlatformAdmin(context);
    MaterialApp materialApp;
    if(kIsWeb){
      materialApp = MaterialApp(title: "SNKRS APP",
        routes: {
          '/loginview':(context) => LoginView(),
          '/registerview':(context) => RegisterView(),
          '/perfilcreateview':(context) => PerfilCreateView(),
          '/homeview':(context) => HomeView(),
          '/drawerview':(context) => DrawerClass(),
          '/postview':(context) => PostView(),
          '/postcreateview':(context) => PostCreateView(),
          '/mapaview':(context) => MapaView(),
          '/perfilview':(context) => PerfilView(),
          '/splashview':(context) => SplashView(),
        },
        initialRoute: '/loginview',
        debugShowCheckedModeBanner: false,
      );
    }else{
      materialApp = MaterialApp(title: "SNKRS APP",
        routes: {
          '/loginview':(context) => PhoneLoginView(),
          '/registerview':(context) => RegisterView(),
          '/perfilcreateview':(context) => PerfilCreateView(),
          '/homeview':(context) => HomeView(),
          '/drawerview':(context) => DrawerClass(),
          '/postview':(context) => PostView(),
          '/postcreateview':(context) => PostCreateView(),
          '/mapaview':(context) => MapaView(),
          '/perfilview':(context) => PerfilView(),
          '/splashview':(context) => SplashView(),
        },
        initialRoute: '/loginview',
        debugShowCheckedModeBanner: false,
      );
    }

    return materialApp;
  }

}