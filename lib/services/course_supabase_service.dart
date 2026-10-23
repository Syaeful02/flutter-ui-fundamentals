// 2415051059 - Syaeful Darmawan

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  // Mengambil instance Supabase yang sudah diinisialisasi di main.dart
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // Melakukan SELECT * FROM courses ORDER BY id
    final data = await supabase
        .from('courses')
        .select()
        .order('id', ascending: true);

    // Konversi response menjadi List<Course>
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    // Akan diimplementasikan di Tahap 13
    throw UnimplementedError('Belum diimplementasikan');
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    // Akan diimplementasikan di Tahap 14
    throw UnimplementedError('Belum diimplementasikan');
  }

  @override
  Future<void> deleteCourse(int id) async {
    // Akan diimplementasikan di Tahap 15
    throw UnimplementedError('Belum diimplementasikan');
  }
}