// 2415051059 - Syaeful Darmawan

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id', ascending: true);

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    // INSERT data ke tabel courses
    final response = await supabase
        .from('courses')
        .insert({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .select() // Minta Supabase mengembalikan data yang baru di-insert
        .single(); // Ambil satu baris (object), bukan list

    // Konversi response (Map) kembali ke model Course
    return Course.fromJson(response);
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