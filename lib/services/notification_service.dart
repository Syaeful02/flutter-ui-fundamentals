// 2415051059 - Syaeful Darmawan

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Meminta izin notifikasi dan mengembalikan statusnya
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('====================================');
    debugPrint('Status Izin Notifikasi: ${settings.authorizationStatus.name}');
    debugPrint('====================================');
    
    return settings.authorizationStatus;
  }

  /// Inisialisasi lengkap (Izin + Token + Listener)
  Future<void> init() async {
    // 1. Minta izin
    await requestPermission();

    // 2. Ambil Token via register (Web)
    try {
      _messaging.onRegistered.listen((fid) {
        debugPrint('=== FCM Token Diterima ===');
        debugPrint(fid);
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