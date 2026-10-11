// 2415051059 - Syaeful Darmawan
// Demo ValueNotifier — pola listener sederhana.

import 'package:flutter/material.dart';

class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  final ValueNotifier<int> _favoriteCount = ValueNotifier<int>(0);

  @override
  void dispose() {
    _favoriteCount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo ValueNotifier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Nilai di bawah di-observe oleh ValueListenableBuilder.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: _favoriteCount,
              builder: (context, value, child) {
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '$value',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filledTonal(
                      onPressed: value > 0
                          ? () => _favoriteCount.value -= 1
                          : null,
                      icon: const Icon(Icons.remove),
                      tooltip: 'Kurangi',
                    ),
                    const SizedBox(width: 4),
                    IconButton.filledTonal(
                      onPressed: () => _favoriteCount.value += 1,
                      icon: const Icon(Icons.add),
                      tooltip: 'Tambah',
                    ),
                    if (child != null) ...[
                      const SizedBox(width: 12),
                      child,
                    ],
                  ],
                );
              },
              child: const Text(
                '(statis)',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}