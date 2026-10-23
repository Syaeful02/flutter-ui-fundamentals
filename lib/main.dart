// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

import 'config/supabase_config.dart'; // Import Config
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/main_shell.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart'; // Import Service Supabase

Future<void> main() async {
  // 1. Inisialisasi Supabase
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  // ============================================================
  // RAKIT DEPENDENCY
  // ============================================================
  // 2. Pilih Data Source aktif (Sekarang pakai Supabase)
  final CourseDataSource dataSource = CourseSupabaseService();

  // 3. Masukkan ke Repository
  final repository = CourseRepository(dataSource);
  // ============================================================

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
      title: 'Course Explorer v2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}