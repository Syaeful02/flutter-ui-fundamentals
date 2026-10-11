// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feedback_form.dart';

class ProfileTab extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onClearFavorites;

  const ProfileTab({
    super.key,
    required this.student,
    required this.onClearFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const ProfileAvatar(radius: 56, backgroundColor: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(
              student['name'] as String,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'NIM: ${student['nim']}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 28),
            ProfileItem(
              icon: Icons.school_outlined,
              label: 'Program Studi',
              value: student['program'] as String,
            ),
            ProfileItem(
              icon: Icons.location_city_outlined,
              label: 'Universitas',
              value: student['university'] as String,
            ),
            ProfileItem(
              icon: Icons.calendar_today_outlined,
              label: 'Semester',
              value: '${student['semester']}',
            ),
            Consumer<CourseState>(
              builder: (context, courseState, _) {
                return ProfileItem(
                  icon: Icons.favorite_outline,
                  label: 'Course Difavoritkan',
                  value: '${courseState.favoriteCount} course',
                  trailing: courseState.favoriteCount > 0
                      ? IconButton(
                          icon: const Icon(
                            Icons.delete_sweep_outlined,
                            color: Colors.red,
                          ),
                          tooltip: 'Hapus semua favorite',
                          onPressed: onClearFavorites,
                        )
                      : null,
                );
              },
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            FeedbackForm(student: student),
          ],
        ),
      ),
    );
  }
}