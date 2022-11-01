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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD9N--3QoI7qeWaWm7NUrbkXzxXmnm3mO0',
    appId: '1:714156128986:web:0382d8e476e98bda7a43e3',
    messagingSenderId: '714156128986',
    projectId: 'meme-tournament-assistant',
    authDomain: 'meme-tournament-assistant.firebaseapp.com',
    storageBucket: 'meme-tournament-assistant.appspot.com',
    measurementId: 'G-TJQTGDGQ3K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5GP3bRrnuYmAH9qT5jvpt9--AP_fhVMs',
    appId: '1:714156128986:android:c304832b72dd0a487a43e3',
    messagingSenderId: '714156128986',
    projectId: 'meme-tournament-assistant',
    storageBucket: 'meme-tournament-assistant.appspot.com',
  );
}
