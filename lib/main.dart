// 2415051059 - Syaeful Darmawan
// Course Explorer v2 — Main entry point.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'providers/course_state.dart';
import 'repositories/course_repository.dart';
import 'screens/main_shell.dart';
import 'services/course_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Shared favorites state
        ChangeNotifierProvider(create: (_) => CourseState()),

        // Async state (loading/error/success) untuk data course
        ChangeNotifierProvider(
          create: (_) => CourseProvider(
            CourseRepository(CourseService()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course Explorer v2',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}