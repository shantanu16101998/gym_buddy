// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDsgdDjsIJLxvFErCBA4T6TxgdBOAx_eeA',
    appId: '1:238919553642:web:f396fbca3f0a95178d7013',
    messagingSenderId: '238919553642',
    projectId: 'gym-buddy-57fc6',
    authDomain: 'gym-buddy-57fc6.firebaseapp.com',
    storageBucket: 'gym-buddy-57fc6.appspot.com',
    measurementId: 'G-HCGE919JZ7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB779bwhlUDG-ohmZlBQhG-XNxWIyZzMKk',
    appId: '1:238919553642:android:74a6070456cadc138d7013',
    messagingSenderId: '238919553642',
    projectId: 'gym-buddy-57fc6',
    storageBucket: 'gym-buddy-57fc6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCbDtTxh-3qB1e_Jo-vzaEhAV71wd0sKY',
    appId: '1:238919553642:ios:9cebba237afe9db88d7013',
    messagingSenderId: '238919553642',
    projectId: 'gym-buddy-57fc6',
    storageBucket: 'gym-buddy-57fc6.appspot.com',
    iosBundleId: 'com.gymbuddy.gymBuddy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCbDtTxh-3qB1e_Jo-vzaEhAV71wd0sKY',
    appId: '1:238919553642:ios:9cebba237afe9db88d7013',
    messagingSenderId: '238919553642',
    projectId: 'gym-buddy-57fc6',
    storageBucket: 'gym-buddy-57fc6.appspot.com',
    iosBundleId: 'com.gymbuddy.gymBuddy',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDsgdDjsIJLxvFErCBA4T6TxgdBOAx_eeA',
    appId: '1:238919553642:web:75f664db190443f78d7013',
    messagingSenderId: '238919553642',
    projectId: 'gym-buddy-57fc6',
    authDomain: 'gym-buddy-57fc6.firebaseapp.com',
    storageBucket: 'gym-buddy-57fc6.appspot.com',
    measurementId: 'G-B6SCM1E75P',
  );
}
