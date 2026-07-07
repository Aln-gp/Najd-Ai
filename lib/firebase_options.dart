import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_YOUR_ANDROID_API_KEY',
    appId: '1:123456789:android:abcdef1234567890abcd',
    messagingSenderId: '123456789',
    projectId: 'najd-ai-project',
    storageBucket: 'najd-ai-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_YOUR_IOS_API_KEY',
    appId: '1:123456789:ios:abcdef1234567890abcd',
    messagingSenderId: '123456789',
    projectId: 'najd-ai-project',
    storageBucket: 'najd-ai-project.appspot.com',
    iosBundleId: 'com.najdai.app',
  );
}
