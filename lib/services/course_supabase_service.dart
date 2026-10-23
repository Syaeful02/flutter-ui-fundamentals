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
    final response = await supabase
        .from('courses')
        .insert({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .select()
        .single();

    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase
        .from('courses')
        .update({
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    // DELETE data dari tabel courses berdasarkan ID
    await supabase
        .from('courses')
        .delete()
        .eq('id', id);
  }
}