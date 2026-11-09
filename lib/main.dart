// 2415051059 - Syaeful Darmawan

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'firebase_options.dart'; // File konfigurasi Firebase
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/login_page.dart'; // Import LoginPage
import 'screens/main_shell.dart';
import 'services/auth_service.dart'; // Import AuthService untuk cek session
import 'services/course_supabase_service.dart';
import 'services/course_data_source.dart';
import 'services/notification_service.dart'; // Import NotificationService

// ============================================================
// HANDLER NOTIFIKASI (BACKGROUND / TERMINATED)
// Fungsi ini harus berada di luar class (top-level function)
// ============================================================
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inisialisasi Firebase dibutuhkan di background isolate
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("=== [BACKGROUND] Notifikasi Diterima ===");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. INISIALISASI FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Daftarkan handler untuk notifikasi saat aplikasi di background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 2. INISIALISASI SUPABASE
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  // 3. INISIALISASI NOTIFIKASI (Minta Izin & Ambil Token)
  await NotificationService.instance.init();

  // 4. RAKIT DEPENDENCY (Data Source -> Repository -> Provider)
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  // 5. JALANKAN APLIKASI DENGAN PROVIDER
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseState()),
        ChangeNotifierProvider(
          create: (_) => CourseProvider(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // CEK SESSION LOGIN
      // Jika sudah login, langsung ke MainShell (Home).
      // Jika belum, arahkan ke LoginPage.
      home: AuthService.instance.isLoggedIn
          ? const MainShell()
          : const LoginPage(),
    );
  }
}