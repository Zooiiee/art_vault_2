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
        return macos;
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
    apiKey: 'AIzaSyD43prTm_5X7s0Zhr11PcWONpA1aLmjKRw',
    appId: '1:1050666510627:web:330526be31aec8c15d0496',
    messagingSenderId: '1050666510627',
    projectId: 'artvault-125cd',
    authDomain: 'artvault-125cd.firebaseapp.com',
    storageBucket: 'artvault-125cd.appspot.com',
    measurementId: 'G-4NCV7XM5RN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqpIUIiPd2tEqH1Q4ccug9d4JHXRiqizg',
    appId: '1:1050666510627:android:8fca55c851d31e025d0496',
    messagingSenderId: '1050666510627',
    projectId: 'artvault-125cd',
    storageBucket: 'artvault-125cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5qis-H57dR5PfhSxNZUrz3JaiJn9aU4g',
    appId: '1:1050666510627:ios:7b10239a5818ed3d5d0496',
    messagingSenderId: '1050666510627',
    projectId: 'artvault-125cd',
    storageBucket: 'artvault-125cd.appspot.com',
    iosBundleId: 'com.example.artVault2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5qis-H57dR5PfhSxNZUrz3JaiJn9aU4g',
    appId: '1:1050666510627:ios:7b10239a5818ed3d5d0496',
    messagingSenderId: '1050666510627',
    projectId: 'artvault-125cd',
    storageBucket: 'artvault-125cd.appspot.com',
    iosBundleId: 'com.example.artVault2',
  );
}