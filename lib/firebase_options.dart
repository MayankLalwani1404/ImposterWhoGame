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
    apiKey: 'AIzaSyDEJOMucMy-uvNTj48mOlxHSCPwTADpOhA',
    appId: '1:155307068085:web:43b15f9eacfaebf987ccfc',
    messagingSenderId: '155307068085',
    projectId: 'imposter-who-5a638',
    authDomain: 'imposter-who-5a638.firebaseapp.com',
    storageBucket: 'imposter-who-5a638.firebasestorage.app',
    measurementId: 'G-NW2NSHLZMV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRwFjHGqFhoksVXJK9v5LQguKQ_ItAvFo',
    appId: '1:155307068085:android:697f3e3adc1f102b87ccfc',
    messagingSenderId: '155307068085',
    projectId: 'imposter-who-5a638',
    storageBucket: 'imposter-who-5a638.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASchfrd_e8sIjrUZAXtArtaNsDo6RijBI',
    appId: '1:155307068085:ios:e53f36a5a494f34487ccfc',
    messagingSenderId: '155307068085',
    projectId: 'imposter-who-5a638',
    storageBucket: 'imposter-who-5a638.firebasestorage.app',
    iosBundleId: 'com.example.imposterwhogame',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASchfrd_e8sIjrUZAXtArtaNsDo6RijBI',
    appId: '1:155307068085:ios:e53f36a5a494f34487ccfc',
    messagingSenderId: '155307068085',
    projectId: 'imposter-who-5a638',
    storageBucket: 'imposter-who-5a638.firebasestorage.app',
    iosBundleId: 'com.example.imposterwhogame',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDEJOMucMy-uvNTj48mOlxHSCPwTADpOhA',
    appId: '1:155307068085:web:622220fcd8d89bba87ccfc',
    messagingSenderId: '155307068085',
    projectId: 'imposter-who-5a638',
    authDomain: 'imposter-who-5a638.firebaseapp.com',
    storageBucket: 'imposter-who-5a638.firebasestorage.app',
    measurementId: 'G-8WZKQF6L5W',
  );

}