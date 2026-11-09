// 2415051059 - Syaeful Darmawan

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart'; // <-- IMPORT INI DITAMBAHKAN
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_keys.dart'; // Import messengerKey

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Status Izin Notifikasi: ${settings.authorizationStatus.name}');
    return settings.authorizationStatus;
  }

  Future<void> init() async {
    await requestPermission();

    // 1. Ambil Token
    try {
      _messaging.onRegistered.listen((fid) {
        debugPrint('=== FCM TOKEN DITERIMA ===');
        debugPrint(fid);
        // Panggil fungsi simpan ke Supabase (Opsional)
        // saveTokenToSupabase(fid); 
      });

      await _messaging.register(
        vapidKey: 'BGOXBWVuVqK9l04AAiEBbeDBhSNvsVs7tARObhFK8GKSaBL3wBOzWXz496kj4DB6CqeTLzTL8xwt8YhjC0yWs_U',
      );
    } catch (e) {
      debugPrint('Gagal mendaftarkan FCM: $e');
    }

    // 2. Listener Foreground (Saat aplikasi dibuka)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('=== [FOREGROUND] Notifikasi Diterima ===');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');

      // Tampilkan SnackBar menggunakan messengerKey
      final title = message.notification?.title ?? 'Notifikasi Baru';
      final body = message.notification?.body ?? '';
      
      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  // (OPSIONAL) Simpan token ke database Supabase
  Future<void> saveTokenToSupabase(String token) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client.from('device_tokens').upsert({
      'token': token,
      'user_id': user.id,
      'platform': defaultTargetPlatform.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}