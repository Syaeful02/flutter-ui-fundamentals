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
      title: 'Responsive GridView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const GridResponsivePage(),
    );
  }
}

class GridResponsivePage extends StatelessWidget {
  const GridResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive GridView'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          int crossAxisCount;

          if (width < 600) {
            crossAxisCount = 1;
          } else if (width < 900) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 3;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tahap 5: GridView Responsive',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '$studentId - $studentName',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Lebar browser: ${width.toStringAsFixed(0)} px',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Jumlah kolom: $crossAxisCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return CourseCard(
                      number: index + 1,
                      title: courseNames[index],
                      icon: courseIcons[index],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

const List<String> courseNames = [
  'Jaringan Komputer',
  'Pemrograman Berbasis Web',
  'Pemrograman Mobile',
  'Metodologi Penelitian',
  'Pengembangan Media',
  'Basis Data',
];

const List<IconData> courseIcons = [
  Icons.lan,
  Icons.web,
  Icons.phone_android,
  Icons.menu_book,
  Icons.school,
  Icons.storage,
];

class CourseCard extends StatelessWidget {
  final int number;
  final String title;
  final IconData icon;

  const CourseCard({
    super.key,
    required this.number,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
            ),

            const SizedBox(height: 12),

            Text(
              'Course $number',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}