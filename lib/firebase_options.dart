import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
// unused import removed

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// ); ```
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
    apiKey: 'AIzaSyD_3T114jrJIeQDPJqrB6-u2ScxBRvxP3U',
    appId: '1:1003688930828:web:b2be22bd7f0d95b4168829',
    messagingSenderId: '1003688930828',
    projectId: 'skillspring-144dd',
    authDomain: 'skillspring-144dd.firebaseapp.com',
    storageBucket: 'skillspring-144dd.firebasestorage.app',
    measurementId: 'G-F78XZ0ZZZ1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'replace-with-your-api-key',
    appId: 'replace-with-your-app-id',
    messagingSenderId: 'replace-with-your-sender-id',
    projectId: 'replace-with-your-project-id',
    storageBucket: 'replace-with-your-storage-bucket',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'replace-with-your-api-key',
    appId: 'replace-with-your-app-id',
    messagingSenderId: 'replace-with-your-sender-id',
    projectId: 'replace-with-your-project-id',
    storageBucket: 'replace-with-your-storage-bucket',
    iosBundleId: 'com.example.skillSpring',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'replace-with-your-api-key',
    appId: 'replace-with-your-app-id',
    messagingSenderId: 'replace-with-your-sender-id',
    projectId: 'replace-with-your-project-id',
    storageBucket: 'replace-with-your-storage-bucket',
    iosBundleId: 'com.example.skillSpring',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'replace-with-your-api-key',
    appId: 'replace-with-your-app-id',
    messagingSenderId: 'replace-with-your-sender-id',
    projectId: 'replace-with-your-project-id',
    authDomain: 'replace-with-your-auth-domain',
    storageBucket: 'replace-with-your-storage-bucket',
  );
}

 