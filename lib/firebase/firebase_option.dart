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
      case TargetPlatform.fuchsia:
        break;
      default:
        throw UnimplementedError(
            'Platform not supported: $defaultTargetPlatform');
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDyczJheEZ3BAwy9FBGR5iY27Tx8gF7Duw',
    appId: '1:844852597269:web:d7e20b5b89bebc0f3b741c',
    messagingSenderId: '844852597269',
    projectId: 'parrotpos-52d76',
    storageBucket: 'parrotpos-52d76.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyczJheEZ3BAwy9FBGR5iY27Tx8gF7Duw',
    appId: '1:844852597269:android:d7e20b5b89bebc0f3b741c',
    messagingSenderId: '844852597269',
    projectId: 'parrotpos-52d76',
    storageBucket: 'parrotpos-52d76.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDyczJheEZ3BAwy9FBGR5iY27Tx8gF7Duw',
    appId: '1:844852597269:ios:2e5402e431384f5a3b741c',
    messagingSenderId: '844852597269',
    projectId: 'parrotpos-52d76',
    storageBucket: 'parrotpos-52d76.appspot.com',
    iosClientId:
        '844852597269-50p2h3pp1qr9gce6a564oitjmfojjh99.apps.googleusercontent.com',
    iosBundleId: 'com.parrot.user',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'xxxxxxxxxxxxxxxxxxx',
    appId: 'xxxxxxxxxxxxxxxxxxx',
    messagingSenderId: 'xxxxxxxxxxxxxxxxxxx',
    projectId: 'xxxxxxxxxxxxxxxxxxx',
    databaseURL: 'xxxxxxxxxxxxxxxxxxx',
    storageBucket: 'xxxxxxxxxxxxxxxxxxx',
    androidClientId: 'xxxxxxxxxxxxxxxxxxx',
    iosClientId: 'xxxxxxxxxxxxxxxxxxx',
    iosBundleId: 'xxxxxxxxxxxxxxxxxxx',
  );
}
