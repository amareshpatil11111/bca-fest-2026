import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  // Flag to identify if we are using the live Firebase setup or local mock fallback
  static bool get isConfigured {
    return web.apiKey.isNotEmpty && web.apiKey != 'YOUR_API_KEY_HERE';
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions have not been configured for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    appId: 'YOUR_APP_ID',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );
}
