import 'package:flutter/material.dart';

class DebugBUnbounded extends StatelessWidget {
  const DebugBUnbounded({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug B — Unbounded Height')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Header di atas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ============================================
          // ❌ VERSI BERMASALAH — ListView di dalam Column tanpa batas
          // ============================================
          // ListView(
          //   children: const [
          //     ListTile(title: Text('Item 1')),
          //     ListTile(title: Text('Item 2')),
          //     ListTile(title: Text('Item 3')),
          //     ListTile(title: Text('Item 4')),
          //     ListTile(title: Text('Item 5')),
          //   ],
          // ),

          // ============================================
          // ✅ VERSI DIPERBAIKI — bungkus ListView dengan Expanded
          //    (comment-kan blok ❌ di atas, uncomment blok ini)
          // ============================================
          Expanded(
            child: ListView(
              children: const [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
                ListTile(title: Text('Item 3')),
                ListTile(title: Text('Item 4')),
                ListTile(title: Text('Item 5')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}