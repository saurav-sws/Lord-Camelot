
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkvUS85tHgtm6iNs2RvACVFSMuqixJjVY',
    appId: '1:284467535125:android:f8b8e68326c4d9ac7d1d1c',
    messagingSenderId: '284467535125',
    projectId: 'lordcamelot-point',
    storageBucket: 'lordcamelot-point.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5tvfSS-bUbgg8tWM0tav1R1aNJFg8hQA',
    appId: '1:284467535125:ios:dd6d404c81bcf4c27d1d1c',
    messagingSenderId: '284467535125',
    projectId: 'lordcamelot-point',
    storageBucket: 'lordcamelot-point.firebasestorage.app',
    iosBundleId: 'com.example.lordcamelotPoint',
  );
}
