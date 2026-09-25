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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Foto profil
              CircleAvatar(
                radius: 46,
                backgroundImage: const AssetImage(
                  'assets/images/profile_syaeful.jpg',
                ),
              ),

              const SizedBox(height: 12),

              // Nama
              Text(
                studentName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // NIM
              Text(
                studentId,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

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

              const SizedBox(height: 20),

              // Card informasi
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Informasi mahasiswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Saya adalah mahasiswa pendidikan teknik informatika semester 5 di universtas pendidikan ganesha. Saya sedang mempelajari Flutter UI Fundamentals, yang mencakup berbagai konsep dan praktik dalam pengembangan antarmuka pengguna menggunakan Flutter, '
                        'saat ini sedang belajar pemrograman berbasis mobile.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Statistik
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
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
                        SizedBox(height: 4),
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
                        SizedBox(height: 4),
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
                        SizedBox(height: 4),
                        Text('State'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Container tambahan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Flutter UI Practice',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Belajar membuat antarmuka aplikasi '
                      'menggunakan widget Flutter.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}