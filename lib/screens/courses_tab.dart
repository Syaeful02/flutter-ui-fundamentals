import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesTab extends StatelessWidget {
  final List<Course> courses;
  final void Function(String code, {bool showFeedback}) onToggleFavorite;

  const CoursesTab({
    super.key,
    required this.courses,
    required this.onToggleFavorite,
  });

  void _openDetail(BuildContext context, Course course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
  }

  void _showQuickInfo(BuildContext context, Course course) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(course.title),
        content: Text(
          'Kode: ${course.code}\nSKS: ${course.credits}\nStatus: ${course.status}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _openDetail(context, course);
            },
            child: const Text('Buka Detail'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRemoveFavorite(
      BuildContext context, Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus dari Favorite?'),
        content: Text('"${course.title}" akan dihapus dari daftar favorite.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      onToggleFavorite(course.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: courses.isEmpty
          ? const Center(child: Text('Data course belum tersedia.'))
          : Consumer<CourseState>(
              builder: (context, courseState, _) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: courses.length,
                  itemBuilder: (context, i) {
                    final c = courses[i];
                    final isFav = courseState.isFavorite(c.code);
                    return CourseCard(
                      course: c,
                      isFavorite: isFav,
                      onTap: () => _openDetail(context, c),
                      onToggleFavorite: () {
                        if (isFav) {
                          _confirmRemoveFavorite(context, c);
                        } else {
                          onToggleFavorite(c.code);
                        }
                      },
                      onLongPress: () => _showQuickInfo(context, c),
                    );
                  },
                );
              },
            ),
    );
  }
}

// ============================================================
// EXPANDED — Master-Detail
// ============================================================
class CoursesMasterDetail extends StatelessWidget {
  final List<Course> courses;
  final Course? selectedCourse;
  final void Function(Course) onSelect;
  final void Function(String code, {bool showFeedback}) onToggleFavorite;

  const CoursesMasterDetail({
    super.key,
    required this.courses,
    required this.selectedCourse,
    required this.onSelect,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses (Master-Detail)')),
      body: Row(
        children: [
          SizedBox(
            width: 340,
            child: courses.isEmpty
                ? const Center(child: Text('Data kosong'))
                : Consumer<CourseState>(
                    builder: (context, courseState, _) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: courses.length,
                        itemBuilder: (context, i) {
                          final c = courses[i];
                          final isFav = courseState.isFavorite(c.code);
                          final isSelected = selectedCourse?.code == c.code;
                          return CourseCard(
                            course: c,
                            isFavorite: isFav,
                            isSelected: isSelected,
                            onTap: () => onSelect(c),
                            onToggleFavorite: () => onToggleFavorite(c.code),
                            onLongPress: () {},
                          );
                        },
                      );
                    },
                  ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: selectedCourse == null
                ? const EmptyDetailPlaceholder()
                : _DetailPanel(course: selectedCourse!),
          ),
        ],
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  final Course course;

  const _DetailPanel({required this.course});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(course.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
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
                  course.title,
                  style: const TextStyle(
                    fontSize: 24,
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
            'Mata kuliah ${course.title} dengan kode ${course.code} '
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
        ],
      ),
    );
  }
}