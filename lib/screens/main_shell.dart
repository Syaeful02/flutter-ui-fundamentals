// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';
import 'courses_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  Course? _selectedCourse;

  void _toggleFavorite(String code, {bool showFeedback = true}) {
    final courseState = context.read<CourseState>();
    final courseProvider = context.read<CourseProvider>();

    final wasFav = courseState.isFavorite(code);
    courseState.toggleFavorite(code);

    if (showFeedback) {
      final course = courseProvider.courses.firstWhere((c) => c.code == code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${course.name}" ${wasFav ? 'dihapus dari' : 'ditambahkan ke'} Favorite',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // -------- Loading --------
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat data course...'),
            ],
          ),
        ),
      );
    }

    // -------- Error --------
    if (provider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Explorer v2')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 72, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Gagal memuat data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => provider.loadCourses(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // -------- Success --------
    final student = provider.student!;
    final courses = provider.courses;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 840;

        final pages = [
          HomeTab(student: student, courses: courses),
          isExpanded
              ? CoursesMasterDetail(
                  courses: courses,
                  selectedCourse: _selectedCourse,
                  onSelect: (c) => setState(() => _selectedCourse = c),
                  onToggleFavorite: _toggleFavorite,
                )
              : CoursesTab(
                  courses: courses,
                  onToggleFavorite: _toggleFavorite,
                ),
          ProfileTab(
            student: student,
            onClearFavorites: () {
              context.read<CourseState>().clearFavorites();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua favorite dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ];

        if (isExpanded) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (i) =>
                      setState(() => _currentIndex = i),
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: ProfileAvatar(radius: 22),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: pages),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(index: _currentIndex, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}