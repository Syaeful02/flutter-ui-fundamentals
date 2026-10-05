import 'package:flutter/material.dart';

class DebugAOverflow extends StatelessWidget {
  const DebugAOverflow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug A — Overflow')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kasus A: RenderFlex overflow',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Baris di bawah ini berisi Row + Text panjang. '
              'Versi bermasalah TIDAK memakai Expanded, sehingga overflow.',
            ),
            const SizedBox(height: 24),

            // ============================================
            // ❌ VERSI BERMASALAH — uncomment untuk lihat error
            //    (comment-kan blok ✅ di bawah dulu)
            // ============================================
            // Row(
            //   children: const [
            //     Icon(Icons.info),
            //     SizedBox(width: 8),
            //     Text(
            //       'NIM 2415051059 - Syaeful Darmawan - teks sangat panjang '
            //       'yang akan menyebabkan RenderFlex overflow di layar kecil '
            //       'karena Row tidak membatasi lebar Text ini.',
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ],
            // ),

            // ============================================
            // ✅ VERSI DIPERBAIKI — comment-kan blok ❌ di atas,
            //    lalu uncomment blok ini
            // ============================================
            Row(
              children: const [
                Icon(Icons.info),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NIM 2415051059 - Syaeful Darmawan - teks sangat panjang '
                    'yang akan menyebabkan RenderFlex overflow di layar kecil '
                    'karena Row tidak membatasi lebar Text ini.',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              'Solusi: bungkus Text dengan Expanded + overflow: ellipsis, '
              'atau gunakan Wrap jika teks boleh multi-baris.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}