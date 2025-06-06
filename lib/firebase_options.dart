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
    apiKey: 'AIzaSyAgvF6PPiJg9Xf0z16L_c0Syv1UfX-W668',
    appId: '1:72774460675:web:3bc1c2fb8d6f11f4263536',
    messagingSenderId: '72774460675',
    projectId: 'boutiqueecommerce-3023b',
    authDomain: 'boutiqueecommerce-3023b.firebaseapp.com',
    storageBucket: 'boutiqueecommerce-3023b.firebasestorage.app',
    measurementId: 'G-SV4Y2X7DRH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyo0vyFZAQHUOUaOB70VBNyiG1e50BfQU',
    appId: '1:72774460675:android:498595f4e1a46361263536',
    messagingSenderId: '72774460675',
    projectId: 'boutiqueecommerce-3023b',
    storageBucket: 'boutiqueecommerce-3023b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0uERjuGpHzFdur0QFsxaKp7dtGhkz0AY',
    appId: '1:72774460675:ios:edc6116e8c01a1e6263536',
    messagingSenderId: '72774460675',
    projectId: 'boutiqueecommerce-3023b',
    storageBucket: 'boutiqueecommerce-3023b.firebasestorage.app',
    iosBundleId: 'com.example.gesabscences',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0uERjuGpHzFdur0QFsxaKp7dtGhkz0AY',
    appId: '1:72774460675:ios:edc6116e8c01a1e6263536',
    messagingSenderId: '72774460675',
    projectId: 'boutiqueecommerce-3023b',
    storageBucket: 'boutiqueecommerce-3023b.firebasestorage.app',
    iosBundleId: 'com.example.gesabscences',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3q6XQYrcBf6XzWMRgME35UeqoVrbxmrQ',
    appId: '1:72774460675:web:f75e5c891fb1c773263536',
    messagingSenderId: '72774460675',
    projectId: 'boutiqueecommerce-3023b',
    authDomain: 'boutiqueecommerce-3023b.firebaseapp.com',
    storageBucket: 'boutiqueecommerce-3023b.firebasestorage.app',
    measurementId: 'G-25H90VYT4R',
  );
}
