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
    apiKey: 'AIzaSyBtjjnpteTksvE6QA-gtMzJKWuSXfPtIRM',
    appId: '1:361291139257:android:903c8fd746ff234b12b368',
    messagingSenderId: '361291139257',
    projectId: 'project22-41613',
    storageBucket: 'project22-41613.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFJQ0lx9HSN1Y9gMzvSEffkrCaP3N_R9s',
    appId: '1:361291139257:ios:5220b58074362a8912b368',
    messagingSenderId: '361291139257',
    projectId: 'project22-41613',
    storageBucket: 'project22-41613.appspot.com',
    iosClientId: '361291139257-r1ofsnlietbv091ndpqcqccjbqviv8ne.apps.googleusercontent.com',
    iosBundleId: 'com.example.finalWork',
  );
}
