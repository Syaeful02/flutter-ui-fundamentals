import 'package:flutter/material.dart';

// ============================================
// ❌ VERSI BERMASALAH — tanpa guard
// ============================================
class DebugDDoubleNav extends StatelessWidget {
  const DebugDDoubleNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug D — Double Navigation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Versi BERMASALAH:\n'
                'Klik tombol di bawah 5x dengan cepat.\n'
                'Route akan menumpuk: Detail → Detail → Detail...\n'
                'Butuh back berkali-kali untuk kembali ke Home.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailPage()),
                );
              },
              child: const Text('Buka Detail (Tanpa Guard)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// ✅ VERSI DIPERBAIKI — pakai StatefulWidget + guard flag
//    Untuk pakai versi ini, komentar class DebugDDoubleNav di atas
//    dan uncomment class DebugDFixedNav di bawah
// ============================================
// class DebugDDoubleNav extends StatefulWidget {
//   const DebugDDoubleNav({super.key});
//
//   @override
//   State<DebugDDoubleNav> createState() => _DebugDDoubleNavState();
// }
//
// class _DebugDDoubleNavState extends State<DebugDDoubleNav> {
//   bool _isNavigating = false;
//
//   Future<void> _openDetail() async {
//     if (_isNavigating) return;
//     setState(() => _isNavigating = true);
//
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const DetailPage()),
//     );
//
//     if (!mounted) return;
//     setState(() => _isNavigating = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Debug D — Double Navigation (Fixed)')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Text(
//                 'Versi DIPERBAIKI:\n'
//                 'Klik tombol 5x dengan cepat — hanya 1 route terbuka.\n'
//                 'Tekan back 1x langsung kembali ke Home.',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _isNavigating ? null : _openDetail,
//               child: Text(_isNavigating ? 'Membuka...' : 'Buka Detail (Dengan Guard)'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ============================================
// Detail Page (dipakai di kedua versi)
// ============================================
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Ini halaman Detail.\n\n'
            'Tekan tombol back di AppBar (panah kiri atas).\n\n'
            'Kalau versi bermasalah: kamu akan balik ke Detail lagi '
            '(karena route menumpuk).\n\n'
            'Kalau versi diperbaiki: kamu langsung balik ke Home.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}