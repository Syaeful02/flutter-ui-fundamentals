
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/login_page.dart'; // Import LoginPage
import 'screens/main_shell.dart';
import 'services/auth_service.dart'; // Import AuthService
import 'services/course_supabase_service.dart';
import 'services/course_data_source.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseState()),
        ChangeNotifierProvider(create: (_) => CourseProvider(repository)),
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
      // CEK SESSION DI SINI
      home: AuthService.instance.isLoggedIn
          ? const MainShell() // Jika ada session -> Masuk
          : const LoginPage(), // Jika tidak ada -> Login
    );
  }
}