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
    apiKey: 'AIzaSyACyHOhg_ITlPlN3Hpo0SCwk36K9NzRLdk',
    appId: '1:196147542758:web:8eb6d8afa56f63f730d927',
    messagingSenderId: '196147542758',
    projectId: 'course-notif',
    authDomain: 'course-notif.firebaseapp.com',
    storageBucket: 'course-notif.firebasestorage.app',
  );
}