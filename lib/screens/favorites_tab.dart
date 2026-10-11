// 2415051059 - Syaeful Darmawan
// FavoritesTab — menampilkan course yang difavoritkan.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesTab extends StatelessWidget {
  final List<Course> courses;
  final void Function(String code, {bool showFeedback}) onToggleFavorite;

  const FavoritesTab({
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

  @override
  Widget build(BuildContext context) {
    // WATCH: rebuild saat favorite berubah
    final courseState = context.watch<CourseState>();

    // Filter course yang ada di favorites
    final favoriteCourses = courses
        .where((c) => courseState.isFavorite(c.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (favoriteCourses.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(
                  '${favoriteCourses.length} course',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: favoriteCourses.isEmpty
          ? const _EmptyFavorites()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, i) {
                final c = favoriteCourses[i];
                return CourseCard(
                  course: c,
                  isFavorite: true,
                  onTap: () => _openDetail(context, c),
                  onToggleFavorite: () => onToggleFavorite(c.code),
                  onLongPress: () {},
                );
              },
            ),
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================
class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 96,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Belum ada course favorit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buka tab Courses dan tap ikon ❤️ pada course\n'
              'untuk menambahkannya ke daftar favorit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}