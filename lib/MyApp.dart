import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_psp_pmdm/Custom/DrawerClass.dart';
import 'package:proyecto_psp_pmdm/Main/HomeView.dart';
import 'package:proyecto_psp_pmdm/Main/MapaView.dart';
import 'package:proyecto_psp_pmdm/Main/PostCreateView.dart';
import 'package:proyecto_psp_pmdm/Main/PostView.dart';
import 'package:proyecto_psp_pmdm/Main/ProfileEditView.dart';
import 'package:proyecto_psp_pmdm/Main/SettingsView.dart';
import 'package:proyecto_psp_pmdm/Main/WishlistView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/LoginView.dart';
import 'package:proyecto_psp_pmdm/OnBoarding/LoginViewNew.dart';
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
          '/loginview':(context) => LoginViewNew(),
          '/registerview':(context) => RegisterView(),
          '/perfilcreateview':(context) => PerfilCreateView(),
          '/homeview':(context) => HomeView(),
          '/drawerview':(context) => DrawerClass(),
          '/postview':(context) => PostView(),
          '/postcreateview':(context) => PostCreateView(),
          '/mapaview':(context) => MapaView(),
          '/perfilview':(context) => PerfilView(),
          '/splashview':(context) => SplashView(),
          '/wishlist' :(context) => WishlistView(),
          '/phoneloginview' :(context) => PhoneLoginView(),
          '/settingsview' :(context) => SettingsView(),
          '/profileeditview' :(context) => ProfileEditView()
        },
        initialRoute: '/splashview',
        debugShowCheckedModeBanner: false,
      );
    }else{
      materialApp = MaterialApp(title: "SNKRS APP",
        routes: {
          '/loginview':(context) => LoginViewNew(),
          '/registerview':(context) => RegisterView(),
          '/perfilcreateview':(context) => PerfilCreateView(),
          '/homeview':(context) => HomeView(),
          '/drawerview':(context) => DrawerClass(),
          '/postview':(context) => PostView(),
          '/postcreateview':(context) => PostCreateView(),
          '/mapaview':(context) => MapaView(),
          '/perfilview':(context) => PerfilView(),
          '/splashview':(context) => SplashView(),
          '/wishlist' :(context) => WishlistView(),
          '/phoneloginview' :(context) => PhoneLoginView(),
          '/settingsview' :(context) => SettingsView(),
          '/profileeditview' :(context) => ProfileEditView()
        },
        initialRoute: '/loginview',
        debugShowCheckedModeBanner: false,
      );
    }

    return materialApp;
  }

}