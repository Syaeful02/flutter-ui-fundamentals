// 2415051059 - Syaeful Darmawan

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('Platform not supported');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'ISI_API_KEY_KAMU',
    appId: 'ISI_APP_ID_KAMU',
    messagingSenderId: 'ISI_SENDER_ID_KAMU',
    projectId: 'ISI_PROJECT_ID_KAMU',
    authDomain: 'ISI_AUTH_DOMAIN_KAMU',
    storageBucket: 'ISI_STORAGE_BUCKET_KAMU',
  );
}