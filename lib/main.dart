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

  // Collection data materi
  final List<Map<String, dynamic>> topics = const [
    {
      'title': 'Widget Dasar',
      'description': 'Mempelajari widget dasar Flutter.',
      'icon': Icons.widgets,
    },
    {
      'title': 'Layout Flutter',
      'description': 'Mempelajari Row, Column, Padding, dan Container.',
      'icon': Icons.dashboard,
    },
    {
      'title': 'StatefulWidget',
      'description': 'Mempelajari state dan perubahan tampilan.',
      'icon': Icons.sync,
    },
    {
      'title': 'Input User',
      'description': 'Mempelajari TextField dan pengolahan input.',
      'icon': Icons.input,
    },
    {
      'title': 'JSON Data',
      'description': 'Mempelajari penggunaan data JSON pada Flutter.',
      'icon': Icons.data_object,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Identitas mahasiswa
            CircleAvatar(
              radius: 46,
              backgroundImage: const AssetImage(
                'assets/images/profile_syaeful.jpg',
              ),
            ),

            const SizedBox(height: 12),

            Text(
              studentName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              studentId,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

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

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Materi yang Dipelajari',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List materi
            Expanded(
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final topic = topics[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
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
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
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