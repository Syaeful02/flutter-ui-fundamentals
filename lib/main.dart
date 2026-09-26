import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  // Membaca file JSON dari assets
  Future<Map<String, dynamic>> loadStudentData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

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
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Terjadi kesalahan saat membaca data:\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Data kosong
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data tidak tersedia.',
              ),
            );
          }

          // Data berhasil dibaca
          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          final String name =
              student['name'] as String;

          final String nim =
              student['nim'] as String;

          final String program =
              student['program'] as String;

          final int semester =
              student['semester'] as int;

          final String university =
              student['university'] as String;

          return Padding(
            padding: const EdgeInsets.all(20),
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

                // Nama dari JSON
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // NIM dari JSON
                Text(
                  nim,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                // Program studi dan semester
                Text(
                  '$program • Semester $semester',
                  textAlign: TextAlign.center,
                ),

                Text(
                  university,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Statistik
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

                // Judul mata kuliah
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mata Kuliah',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Daftar mata kuliah
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course =
                          courses[index] as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.menu_book,
                            size: 32,
                          ),
                          title: Text(
                            course['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${course['code']} • '
                            '${course['credits']} SKS',
                          ),
                          trailing: Text(
                            course['status'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}