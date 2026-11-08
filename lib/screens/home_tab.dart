// 2415051059 - Syaeful Darmawan

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../models/user_profile.dart';
import '../providers/course_provider.dart'; // Import untuk clearProfile
import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/counter_demo.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import 'login_page.dart';

class HomeTab extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<Course> courses;

  const HomeTab({super.key, required this.student, required this.courses});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _showSummary = true;
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    // 1. Bersihkan memori profil dari Provider
    context.read<CourseProvider>().clearProfile();
    
    // 2. Logout dari Supabase
    await AuthService.instance.logout();
    if (!mounted) return;
    
    // 3. Kembali ke halaman Login
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            tooltip: _showSummary ? 'Sembunyikan summary' : 'Tampilkan summary',
            icon: Icon(_showSummary ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showSummary = !_showSummary),
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final profile = snapshot.data;
          final roleText = profile?.role.toUpperCase() ?? 'UNKNOWN';
          final nameText = profile?.name.isEmpty == true ? widget.student['name'] : profile?.name;
          final emailText = profile?.email ?? 'Tidak ada email';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- HEADER IDENTITAS ---
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
                    const ProfileAvatar(radius: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameText ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailText,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Role: $roleText',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                      child: SummaryCard(
                        icon: Icons.menu_book_outlined,
                        label: 'Total Course',
                        value: '${widget.courses.length}',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SummaryCard(
                        icon: Icons.favorite_outline,
                        label: 'Favorite',
                        value: '${courseState.favoriteCount}',
                        color: Colors.red,
                      ),
                    ),
                  ],
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
              ...widget.courses.take(3).map((c) => MiniCourseTile(course: c)),
            ],
          );
        },
      ),
    );
  }
}