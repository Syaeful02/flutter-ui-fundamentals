import 'package:flutter/material.dart';

const String studentName = 'Syaeful Darmawan';
const String studentId = '2415051059';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter UI Fundamentals',
      home: const LearningPage(),
    );
  }
}

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Foto profil
            CircleAvatar(
              radius: 46,
              backgroundImage: const AssetImage(
                'assets/images/profile_syaeful.jpg',
              ),
            ),

            const SizedBox(height: 12),

            // Nama mahasiswa
            Text(
              studentName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // NIM
            Text(studentId),

            const SizedBox(height: 8),

            // Informasi mahasiswa
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_android),
                SizedBox(width: 8),
                Text('Mobile Programming Student'),
              ],
            ),

            const SizedBox(height: 24),

            // Statistik
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    Text(
                      '8',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Widget'),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      '4',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Layout'),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      '1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('State'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}