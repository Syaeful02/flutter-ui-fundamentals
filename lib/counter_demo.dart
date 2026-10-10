// 2415051059 - Syaeful Darmawan
//
// Demo ValueNotifier: pola listener sederhana untuk satu nilai.
// Nilai ini dipisahkan dari setState dan bisa di-observe oleh
// ValueListenableBuilder untuk rebuild area kecil saja.

import 'package:flutter/material.dart';

class CounterDemo extends StatefulWidget {
  const CounterDemo({super.key});

  @override
  State<CounterDemo> createState() => _CounterDemoState();
}

class _CounterDemoState extends State<CounterDemo> {
  // 🟢 Nilai di-manage oleh ValueNotifier, bukan State lokal
  final ValueNotifier<int> _favoriteCount = ValueNotifier<int>(0);

  @override
  void dispose() {
    // WAJIB: dispose notifier supaya tidak memory leak
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Nilai di bawah ini di-observe oleh ValueListenableBuilder. '
              'Ketika nilainya berubah, hanya angka + tombol yang rebuild.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),

            // 🟢 Hanya bagian ini yang listen ke notifier
            ValueListenableBuilder<int>(
              valueListenable: _favoriteCount,
              builder: (context, value, child) {
                return Row(
                  children: [
                    // Ikon + angka — rebuild saat value berubah
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

                    // Tombol -/+ mengubah notifier.value
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

                    // 🎯 `child` adalah widget statis yang tidak perlu rebuild
                    //    (dikirim sekali, tidak dibangun ulang saat value berubah)
                    if (child != null) ...[
                      const SizedBox(width: 12),
                      child,
                    ],
                  ],
                );
              },
              // `child` ini tidak rebuild saat value berubah
              child: const Text(
                '(statis, tidak rebuild)',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}