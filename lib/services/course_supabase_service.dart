// 2415051059 - Syaeful Darmawan

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  @override
  Future<List<Course>> getCourses() async {
    // Akan diimplementasikan di Tahap 12
    throw UnimplementedError('Belum diimplementasikan');
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