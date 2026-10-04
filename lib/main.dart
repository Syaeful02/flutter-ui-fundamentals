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
      title: 'MediaQuery Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MediaQueryPage(),
    );
  }
}

class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final Orientation orientation = mediaQuery.orientation;

    final bool isWide = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediaQuery'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 2: MediaQuery',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    studentId,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    studentName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Lebar layar: ${screenWidth.toStringAsFixed(1)} px',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tinggi layar: ${screenHeight.toStringAsFixed(1)} px',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Orientasi: ${orientation == Orientation.portrait ? 'Portrait' : 'Landscape'}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Kategori layar: ${isWide ? 'Wide' : 'Compact'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isWide
                    ? 'Layar cukup lebar sehingga ruang tampilan lebih luas.'
                    : 'Layar lebih kecil sehingga tampilan menggunakan ruang yang lebih terbatas.',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Catatan: MediaQuery digunakan untuk mendapatkan informasi tentang ukuran layar, orientasi, dan kategori layar. Dengan informasi ini, kita dapat membuat tampilan yang responsif dan menyesuaikan tata letak sesuai dengan ukuran layar perangkat.',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 