// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(course.status);

    return Scaffold(
      appBar: AppBar(title: const Text('Course Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.85),
                    color.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.code,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ChipPill(
                        icon: Icons.school_outlined,
                        text: '${course.credits} SKS',
                      ),
                      const SizedBox(width: 8),
                      ChipPill(icon: Icons.info_outline, text: course.status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Deskripsi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Mata kuliah ${course.name} dengan kode ${course.code} '
              'berbobot ${course.credits} SKS. Status saat ini: ${course.status}.',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Informasi Mahasiswa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Syaeful Darmawan'),
            const Text('NIM: 2415051059'),
            const Text('Pendidikan Teknik Informatika'),
            const Text('Universitas Pendidikan Ganesha'),
            const SizedBox(height: 32),

            Consumer<CourseState>(
              builder: (context, courseState, _) {
                final isFav = courseState.isFavorite(course.code);
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      context
                          .read<CourseState>()
                          .toggleFavorite(course.code);
                      Navigator.pop(context, true);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: isFav ? Colors.grey : Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    label: Text(
                      isFav ? 'Hapus dari Favorit' : 'Pilih / Favoritkan',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}