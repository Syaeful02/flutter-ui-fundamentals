import 'package:flutter/material.dart';

class DebugCKeyboard extends StatelessWidget {
  const DebugCKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================
    // ❌ VERSI BERMASALAH — Column tanpa scroll
    //    Layout akan overflow di layar pendek
    // ============================================
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Debug C — Keyboard Overflow')),
    //   body: Column(
    //     children: [
    //       const SizedBox(height: 200),
    //       const Text(
    //         'Kasus C: konten lebih tinggi dari layar',
    //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //       ),
    //       const SizedBox(height: 20),
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16),
    //         child: TextField(
    //           decoration: InputDecoration(
    //             labelText: 'Ketik di sini...',
    //             border: const OutlineInputBorder(),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 200),
    //       const Text('Konten di bawah'),
    //       const SizedBox(height: 200),
    //       ElevatedButton(
    //         onPressed: () {},
    //         child: const Text('Kirim'),
    //       ),
    //       const SizedBox(height: 40),
    //     ],
    //   ),
    // );

    // ============================================
    // ✅ VERSI DIPERBAIKI — bungkus Column dengan SingleChildScrollView
    //    Comment-kan blok ❌ di atas (return Scaffold pertama),
    //    lalu uncomment blok ini
    // ============================================
    return Scaffold(
      appBar: AppBar(title: const Text('Debug C — Keyboard Overflow')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 200),
            const Text(
              'Kasus C: konten lebih tinggi dari layar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Ketik di sini...',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 200),
            const Text('Konten di bawah'),
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Kirim'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}