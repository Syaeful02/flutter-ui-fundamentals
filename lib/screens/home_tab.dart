// 2415051059 - Syaeful Darmawan

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/course.dart';
import '../providers/course_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/counter_demo.dart';

class HomeTab extends StatefulWidget {
  final Map<String, dynamic> student;
  final List<Course> courses;

  const HomeTab({super.key, required this.student, required this.courses});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _showSummary = true;

  // State sementara untuk Tahap 2 (HTTP GET)
  List<Course>? _apiCourses;
  bool _isFetching = false;

  Future<void> _fetchApiData() async {
    setState(() => _isFetching = true);
    try {
      final response = await http.get(Uri.parse('$apiBaseUrl/posts'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body) as List;
        setState(() {
          // Ambil 3 data pertama dan konversi ke Model Course
          _apiCourses = data.take(3).map((e) => Course.fromJson(e)).toList();
        });
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2'),
        actions: [
          IconButton(
            tooltip: _showSummary ? 'Sembunyikan' : 'Tampilkan',
            icon: Icon(
              _showSummary ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => setState(() => _showSummary = !_showSummary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header identitas
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

          // === Bagian Uji Coba Tahap 2 ===
          ElevatedButton.icon(
            onPressed: _isFetching ? null : _fetchApiData,
            icon: const Icon(Icons.download),
            label: Text(_isFetching ? 'Menarik data...' : 'Uji GET API (Preview)'),
          ),
          if (_apiCourses != null) ...[
            const SizedBox(height: 12),
            const Text('Preview Data API:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._apiCourses!.map((c) => ListTile(
                  title: Text(c.title.length > 30 ? '${c.title.substring(0, 30)}...' : c.title),
                  subtitle: Text('Code: ${c.code} | SKS: ${c.credits}'),
                )),
          ],
          // ==============================

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
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
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
          ...widget.courses.take(3).map((c) => MiniCourseTile(course: c)),
        ],
      ),
    );
  }
}