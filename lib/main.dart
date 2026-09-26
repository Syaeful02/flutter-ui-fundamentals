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
      title: 'Learning Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const LearningDashboard(),
    );
  }
}

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() =>
      _LearningDashboardState();
}

class _LearningDashboardState
    extends State<LearningDashboard> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();

    studentFuture = loadStudentData();
  }

  // Membaca data JSON dari assets
  Future<Map<String, dynamic>> loadStudentData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // Widget reusable untuk kartu statistik
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
              Text(
                label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget reusable untuk menampilkan status mata kuliah
  Widget buildStatus(String status) {
    if (status == 'Selesai') {
      return const Text(
        'Selesai',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (status == 'Sedang Dipelajari') {
      return const Text(
        'Sedang Dipelajari',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return const Text(
      'Belum',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learning Dashboard',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Kondisi loading
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Kondisi error
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

          // Jika data tidak tersedia
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data tidak tersedia.',
              ),
            );
          }

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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // =========================
                // PROFILE
                // =========================
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              const AssetImage(
                            'assets/images/profile_syaeful.jpg',
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          nim,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          program,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          'Semester $semester',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          university,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // SUMMARY
                // =========================
                const Text(
                  'Ringkasan Pembelajaran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    buildStatCard(
                      '5',
                      'Mata Kuliah',
                      Icons.menu_book,
                    ),
                    const SizedBox(width: 8),
                    buildStatCard(
                      '15',
                      'Total SKS',
                      Icons.school,
                    ),
                    const SizedBox(width: 8),
                    buildStatCard(
                      '2',
                      'Sedang Dipelajari',
                      Icons.play_circle,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =========================
                // COURSE LIST
                // =========================
                const Text(
                  'Daftar Mata Kuliah',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...courses.map(
                  (item) {
                    final course =
                        item as Map<String, dynamic>;

                    final String status =
                        course['status'] as String;

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
                        trailing: SizedBox(
                          width: 110,
                          child: buildStatus(status),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // Data tambahan dari JSON
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Data dashboard ini dibaca dari '
                      'student_data.json.',
                      textAlign: TextAlign.center,
                    ),
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