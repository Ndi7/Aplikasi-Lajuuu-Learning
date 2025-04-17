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
    apiKey: 'AIzaSyAmqAjbB6voXzBIj_NhVYVXl2HrvK_jOho',
    appId: '1:663064292672:web:21fe95b3f76cdc80dedea5',
    messagingSenderId: '663064292672',
    projectId: 'lajuuu-learning-firebase',
    authDomain: 'lajuuu-learning-firebase.firebaseapp.com',
    storageBucket: 'lajuuu-learning-firebase.firebasestorage.app',
    measurementId: 'G-44JNVVCWHN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbK48zie7ONaR0voYmkA_V9Y4oRwsnle8',
    appId: '1:663064292672:android:5f1fb004e82a5a16dedea5',
    messagingSenderId: '663064292672',
    projectId: 'lajuuu-learning-firebase',
    storageBucket: 'lajuuu-learning-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRonso4QThzH2Lo9QGYKSv-Kj8ZFjRuD4',
    appId: '1:663064292672:ios:f45b10a90dae8caadedea5',
    messagingSenderId: '663064292672',
    projectId: 'lajuuu-learning-firebase',
    storageBucket: 'lajuuu-learning-firebase.firebasestorage.app',
    iosBundleId: 'com.example.aplikasiLajuuuLearning',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRonso4QThzH2Lo9QGYKSv-Kj8ZFjRuD4',
    appId: '1:663064292672:ios:f45b10a90dae8caadedea5',
    messagingSenderId: '663064292672',
    projectId: 'lajuuu-learning-firebase',
    storageBucket: 'lajuuu-learning-firebase.firebasestorage.app',
    iosBundleId: 'com.example.aplikasiLajuuuLearning',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmqAjbB6voXzBIj_NhVYVXl2HrvK_jOho',
    appId: '1:663064292672:web:c54246839374595ddedea5',
    messagingSenderId: '663064292672',
    projectId: 'lajuuu-learning-firebase',
    authDomain: 'lajuuu-learning-firebase.firebaseapp.com',
    storageBucket: 'lajuuu-learning-firebase.firebasestorage.app',
    measurementId: 'G-NJZNTB74M6',
  );
}
