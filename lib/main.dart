// 2415051059 - Syaeful Darmawan
// Course Explorer v2 — Tahap 6: Provider pada Widget Tree

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'course_state.dart';
import 'counter_demo.dart';

const String studentName = 'Syaeful Darmawan';
const String studentId = '2415051059';
const String profileImagePath = 'assets/images/profile_syaeful.jpg';

void main() {
  runApp(const MyApp());
}

// ============================================================
// MY APP — dibungkus ChangeNotifierProvider
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course Explorer v2',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  Map<String, dynamic>? _selectedCourse;

  Map<String, dynamic>? _student;
  List<dynamic>? _courses;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final raw = await rootBundle.loadString('assets/data/student_data.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    setState(() {
      _student = data['student'] as Map<String, dynamic>;
      _courses = data['courses'] as List<dynamic>;
      _loading = false;
    });
  }

  void _toggleFavorite(String code, {bool showFeedback = true}) {
    final courseState = context.read<CourseState>();
    final wasFav = courseState.isFavorite(code);

    courseState.toggleFavorite(code);

    if (showFeedback) {
      final course = _courses!.firstWhere(
        (c) => (c as Map<String, dynamic>)['code'] == code,
      ) as Map<String, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${course['name']}" ${wasFav ? 'dihapus dari' : 'ditambahkan ke'} Favorite',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Consumer mendengarkan CourseState
    return Consumer<CourseState>(
      builder: (context, courseState, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isExpanded = constraints.maxWidth >= 840;

            final pages = [
              _HomeTab(
                student: _student!,
                courses: _courses!,
                favorites: courseState.favorites,
              ),
              isExpanded
                  ? _CoursesMasterDetail(
                      courses: _courses!,
                      favorites: courseState.favorites,
                      selectedCourse: _selectedCourse,
                      onSelect: (c) => setState(() => _selectedCourse = c),
                      onToggleFavorite: _toggleFavorite,
                    )
                  : _CoursesTab(
                      courses: _courses!,
                      favorites: courseState.favorites,
                      onToggleFavorite: _toggleFavorite,
                    ),
              _ProfileTab(
                student: _student!,
                favoriteCount: courseState.favoriteCount,
                onClearFavorites: () {
                  courseState.clearFavorites();
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
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage:
                              const AssetImage(profileImagePath),
                        ),
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
                      child: IndexedStack(
                        index: _currentIndex,
                        children: pages,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Scaffold(
              body: IndexedStack(index: _currentIndex, children: pages),
              bottomNavigationBar: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (i) =>
                    setState(() => _currentIndex = i),
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
      },
    );
  }
}

// ============================================================
// TAB 1 — HOME
// ============================================================
class _HomeTab extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<dynamic> courses;
  final Set<String> favorites;

  const _HomeTab({
    required this.student,
    required this.courses,
    required this.favorites,
  });

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  bool _showSummary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          IconButton(
            tooltip: _showSummary ? 'Sembunyikan summary' : 'Tampilkan summary',
            icon: Icon(
              _showSummary ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _showSummary = !_showSummary;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(profileImagePath),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student['name'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIM: ${widget.student['nim']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.student['program'] as String,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const CounterDemo(),
          const SizedBox(height: 20),

          if (_showSummary) ...[
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.menu_book_outlined,
                    label: 'Total Course',
                    value: '${widget.courses.length}',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.favorite_outline,
                    label: 'Favorite',
                    value: '${widget.favorites.length}',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Summary disembunyikan (local state demo)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          TextField(
            decoration: InputDecoration(
              hintText: 'Search courses...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Aktif / Terbaru',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...widget.courses.take(3).map((c) {
            final m = c as Map<String, dynamic>;
            return _MiniCourseTile(course: m);
          }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _MiniCourseTile extends StatelessWidget {
  final Map<String, dynamic> course;

  const _MiniCourseTile({required this.course});

  MaterialColor _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Sedang Dipelajari':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(course['status'] as String);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          course['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          course['code'] as String,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            course['status'] as String,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TAB 2a — COURSES (compact)
// ============================================================
class _CoursesTab extends StatelessWidget {
  final List<dynamic> courses;
  final Set<String> favorites;
  final void Function(String code, {bool showFeedback}) onToggleFavorite;

  const _CoursesTab({
    required this.courses,
    required this.favorites,
    required this.onToggleFavorite,
  });

  void _openDetail(BuildContext context, Map<String, dynamic> course) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
  }

  void _showQuickInfo(BuildContext context, Map<String, dynamic> course) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(course['name'] as String),
        content: Text(
          'Kode: ${course['code']}\n'
          'SKS: ${course['credits']}\n'
          'Status: ${course['status']}',
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
      BuildContext context, Map<String, dynamic> course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus dari Favorite?'),
        content: Text(
          '"${course['name']}" akan dihapus dari daftar favorite.',
        ),
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
      onToggleFavorite(course['code'] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, i) {
          final c = courses[i] as Map<String, dynamic>;
          final isFav = favorites.contains(c['code']);
          return _CourseCard(
            course: c,
            isFavorite: isFav,
            onTap: () => _openDetail(context, c),
            onToggleFavorite: () {
              if (isFav) {
                _confirmRemoveFavorite(context, c);
              } else {
                onToggleFavorite(c['code'] as String);
              }
            },
            onLongPress: () => _showQuickInfo(context, c),
          );
        },
      ),
    );
  }
}

// ============================================================
// TAB 2b — COURSES (expanded: master-detail)
// ============================================================
class _CoursesMasterDetail extends StatelessWidget {
  final List<dynamic> courses;
  final Set<String> favorites;
  final Map<String, dynamic>? selectedCourse;
  final void Function(Map<String, dynamic>) onSelect;
  final void Function(String code, {bool showFeedback}) onToggleFavorite;

  const _CoursesMasterDetail({
    required this.courses,
    required this.favorites,
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
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: courses.length,
              itemBuilder: (context, i) {
                final c = courses[i] as Map<String, dynamic>;
                final isFav = favorites.contains(c['code']);
                final isSelected = selectedCourse?['code'] == c['code'];
                return _CourseCard(
                  course: c,
                  isFavorite: isFav,
                  isSelected: isSelected,
                  onTap: () => onSelect(c),
                  onToggleFavorite: () =>
                      onToggleFavorite(c['code'] as String),
                  onLongPress: () {},
                );
              },
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: selectedCourse == null
                ? const _EmptyDetailPlaceholder()
                : _DetailPanel(course: selectedCourse!),
          ),
        ],
      ),
    );
  }
}

class _EmptyDetailPlaceholder extends StatelessWidget {
  const _EmptyDetailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_outlined,
              size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Pilih salah satu course\ndi panel kiri',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  final Map<String, dynamic> course;

  const _DetailPanel({required this.course});

  MaterialColor _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Sedang Dipelajari':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final color = _statusColor(status);

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
                  course['name'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course['code'] as String,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ChipPill(
                      icon: Icons.school_outlined,
                      text: '${course['credits']} SKS',
                    ),
                    const SizedBox(width: 8),
                    _ChipPill(icon: Icons.info_outline, text: status),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Mata kuliah ${course['name']} dengan kode ${course['code']} '
            'berbobot ${course['credits']} SKS. Status saat ini: $status.',
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Informasi Mahasiswa',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
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

// ============================================================
// COURSE CARD
// ============================================================
class _CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onLongPress;

  const _CourseCard({
    required this.course,
    required this.isFavorite,
    this.isSelected = false,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onLongPress,
  });

  MaterialColor _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Sedang Dipelajari':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final color = _statusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 3 : 1.5,
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isSelected
            ? BorderSide(color: Colors.blue.shade300, width: 1.5)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course['code'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${course['credits']} SKS',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleFavorite,
                tooltip: isFavorite
                    ? 'Hapus dari Favorite'
                    : 'Tambah ke Favorite',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TAB 3 — PROFILE
// ============================================================
class _ProfileTab extends StatelessWidget {
  final Map<String, dynamic> student;
  final int favoriteCount;
  final VoidCallback onClearFavorites;

  const _ProfileTab({
    required this.student,
    required this.favoriteCount,
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
            const CircleAvatar(
              radius: 56,
              backgroundColor: Colors.blueAccent,
              backgroundImage: AssetImage(profileImagePath),
            ),
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
            _ProfileItem(
              icon: Icons.school_outlined,
              label: 'Program Studi',
              value: student['program'] as String,
            ),
            _ProfileItem(
              icon: Icons.location_city_outlined,
              label: 'Universitas',
              value: student['university'] as String,
            ),
            _ProfileItem(
              icon: Icons.calendar_today_outlined,
              label: 'Semester',
              value: '${student['semester']}',
            ),
            _ProfileItem(
              icon: Icons.favorite_outline,
              label: 'Course Difavoritkan',
              value: '$favoriteCount course',
              trailing: favoriteCount > 0
                  ? IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.red,
                      ),
                      tooltip: 'Hapus semua favorite',
                      onPressed: onClearFavorites,
                    )
                  : null,
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

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1976D2), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ============================================================
// FEEDBACK FORM
// ============================================================
class FeedbackForm extends StatefulWidget {
  final Map<String, dynamic> student;

  const FeedbackForm({super.key, required this.student});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.student['name'] as String);
    _nimController =
        TextEditingController(text: widget.student['nim'] as String);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Periksa kembali form sebelum mengirim.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kirim Feedback?'),
        content: Text(
          'Feedback dari ${_nameController.text} akan dikirim. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feedback dari ${_nameController.text} '
          '(${_nimController.text}) berhasil dikirim!',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
      ),
    );

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form Feedback',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Sampaikan masukan Anda tentang aplikasi Course Explorer.',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _nimController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'NIM',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'NIM wajib diisi';
              if (s.length < 6) return 'NIM minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 14),

          TextFormField(
            controller: _commentController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              hintText: 'Tulis minimal 5 karakter...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'Komentar wajib diisi';
              if (s.length < 5) return 'Komentar minimal 5 karakter';
              return null;
            },
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_isSubmitting ? 'Mengirim...' : 'Kirim Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// COURSE DETAIL PAGE (compact)
// ============================================================
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  MaterialColor _statusColor(String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Sedang Dipelajari':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;
    final color = _statusColor(status);

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
                    course['name'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course['code'] as String,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _ChipPill(
                        icon: Icons.school_outlined,
                        text: '${course['credits']} SKS',
                      ),
                      const SizedBox(width: 8),
                      _ChipPill(icon: Icons.info_outline, text: status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mata kuliah ${course['name']} dengan kode ${course['code']} '
              'berbobot ${course['credits']} SKS. Status saat ini: $status.',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Informasi Mahasiswa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Syaeful Darmawan'),
            const Text('NIM: 2415051059'),
            const Text('Pendidikan Teknik Informatika'),
            const Text('Universitas Pendidikan Ganesha'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.favorite),
                label: const Text('Pilih / Favoritkan'),
              ),
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

class _ChipPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ChipPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}