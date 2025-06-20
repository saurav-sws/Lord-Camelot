import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBJLLme_9yC5fnt7X2x6rntgBOroLF8jVg',
    appId: '1:894646663100:web:60b23125a7601a32aa5db9',
    messagingSenderId: '894646663100',
    projectId: 'lord-camelot-9099f',
    authDomain: 'lord-camelot-9099f.firebaseapp.com',
    storageBucket: 'lord-camelot-9099f.firebasestorage.app',
    measurementId: 'G-KQKGWVZVEQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCajsR59_Me6eXmxEc13LpiKWoQL9JX5sw',
    appId: '1:894646663100:android:bf0565f41504b025aa5db9',
    messagingSenderId: '894646663100',
    projectId: 'lord-camelot-9099f',
    storageBucket: 'lord-camelot-9099f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGaDFJ1nC6UnJTBEuoWRHt55za3jLb3cg',
    appId: '1:894646663100:ios:80dfc4f03e8df02caa5db9',
    messagingSenderId: '894646663100',
    projectId: 'lord-camelot-9099f',
    storageBucket: 'lord-camelot-9099f.firebasestorage.app',
    iosBundleId: 'com.example.lordcamelotPoint',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGaDFJ1nC6UnJTBEuoWRHt55za3jLb3cg',
    appId: '1:894646663100:ios:80dfc4f03e8df02caa5db9',
    messagingSenderId: '894646663100',
    projectId: 'lord-camelot-9099f',
    storageBucket: 'lord-camelot-9099f.firebasestorage.app',
    iosBundleId: 'com.example.lordcamelotPoint',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBJLLme_9yC5fnt7X2x6rntgBOroLF8jVg',
    appId: '1:894646663100:web:a8b2c4c3e223ae85aa5db9',
    messagingSenderId: '894646663100',
    projectId: 'lord-camelot-9099f',
    authDomain: 'lord-camelot-9099f.firebaseapp.com',
    storageBucket: 'lord-camelot-9099f.firebasestorage.app',
    measurementId: 'G-HEB1ECYQWL',
  );
}
