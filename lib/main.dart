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

  // Reusable Widget untuk statistik
  Widget buildStatCard(
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

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

              // Nama mahasiswa
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

              // Status mahasiswa
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone_android),
                  SizedBox(width: 8),
                  Text('Mobile Programming Student'),
                ],
              ),

              const SizedBox(height: 20),

              // Informasi mahasiswa
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

                      const Text(
                        'Saya adalah mahasiswa Pendidikan Teknik Informatika '
                        'semester 5 di Universitas Pendidikan Ganesha. '
                        'Saya sedang mempelajari Flutter UI Fundamentals '
                        'yang mencakup berbagai konsep dan praktik dalam '
                        'pengembangan antarmuka pengguna menggunakan Flutter. '
                        'Saat ini saya sedang belajar pemrograman berbasis mobile.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Statistik menggunakan reusable widget
              Row(
                children: [
                  buildStatCard(
                    '8',
                    'Widget',
                    Icons.widgets,
                  ),
                  buildStatCard(
                    '4',
                    'Layout',
                    Icons.dashboard,
                  ),
                  buildStatCard(
                    '1',
                    'State',
                    Icons.data_object,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Informasi pembelajaran
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