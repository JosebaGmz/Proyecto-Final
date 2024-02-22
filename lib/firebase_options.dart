// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKe_tR8R6z227EgitZBf-TU-t-WK7_HzU',
    appId: '1:88569760035:web:7dc1d776427ffb337de496',
    messagingSenderId: '88569760035',
    projectId: 'proyecto-final-dam-joseba',
    authDomain: 'proyecto-final-dam-joseba.firebaseapp.com',
    storageBucket: 'proyecto-final-dam-joseba.appspot.com',
    measurementId: 'G-PGG9ZK1MQ0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1wryd-BzQ8lYQzpo5gM7WgBOca49rDqk',
    appId: '1:88569760035:android:b69b33fb144406c17de496',
    messagingSenderId: '88569760035',
    projectId: 'proyecto-final-dam-joseba',
    storageBucket: 'proyecto-final-dam-joseba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrS5IPqPFY1pPF9hCTRppOrR8tJewTfI0',
    appId: '1:88569760035:ios:a2778c8ff6df41587de496',
    messagingSenderId: '88569760035',
    projectId: 'proyecto-final-dam-joseba',
    storageBucket: 'proyecto-final-dam-joseba.appspot.com',
    iosBundleId: 'com.joseba.proyectoPspPmdm',
  );
}