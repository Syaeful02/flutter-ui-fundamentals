// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/main_shell.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';

void main() {
  // ============================================================
  // RAKIT DEPENDENCY DI SINI
  // ============================================================
  // 1. Pilih Data Source aktif
  final CourseDataSource dataSource = CourseApiService(apiBaseUrl);

  // 2. Masukkan ke Repository
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