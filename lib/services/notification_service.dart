// 2415051059 - Syaeful Darmawan

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // 1. Minta izin
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Status Izin: ${settings.authorizationStatus}');
    try {

      _messaging.onRegistered.listen((fid) {
        debugPrint('=== FCM Token / FID Diterima ===');
        debugPrint(fid);
        debugPrint('================================');
      });

      await _messaging.register(
        vapidKey: 'BGOXBWVuVqK9l04AAiEBbeDBhSNvsVs7tARObhFK8GKSaBL3wBOzWXz496kj4DB6CqeTLzTL8xwt8YhjC0yWs_U', 
      );
    } catch (e) {
      debugPrint('Gagal mendaftarkan FCM: $e');
    }

    // 3. Listener saat aplikasi dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('=== [FOREGROUND] Notifikasi Diterima ===');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
    });
  }
}