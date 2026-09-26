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

  // Data materi dan status pembelajaran
  final List<Map<String, dynamic>> topics = const [
    {
      'title': 'Widget Dasar',
      'description': 'Mempelajari widget dasar Flutter.',
      'icon': Icons.widgets,
      'completed': true,
    },
    {
      'title': 'Layout Flutter',
      'description': 'Mempelajari Row, Column, Padding, dan Container.',
      'icon': Icons.dashboard,
      'completed': true,
    },
    {
      'title': 'Reusable Widget',
      'description': 'Mempelajari pembuatan widget yang dapat digunakan kembali.',
      'icon': Icons.widgets_outlined,
      'completed': true,
    },
    {
      'title': 'Input dan State',
      'description': 'Mempelajari TextField, StatefulWidget, dan setState.',
      'icon': Icons.input,
      'completed': true,
    },
    {
      'title': 'Collection dan List',
      'description': 'Mempelajari List dan ListView.builder.',
      'icon': Icons.list,
      'completed': true,
    },
    {
      'title': 'Static JSON',
      'description': 'Mempelajari penggunaan data JSON statik.',
      'icon': Icons.data_object,
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final int completedCount = topics
        .where((topic) => topic['completed'] == true)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      body: Padding(
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

            // Judul dan jumlah materi selesai
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Materi yang Dipelajari',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$completedCount/${topics.length} selesai',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Dynamic List
            Expanded(
              child: ListView.separated(
                itemCount: topics.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  final bool completed = topic['completed'] == true;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        topic['icon'],
                        size: 32,
                      ),
                      title: Text(
                        topic['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        topic['description'],
                      ),
                      trailing: Icon(
                        completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: completed ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}