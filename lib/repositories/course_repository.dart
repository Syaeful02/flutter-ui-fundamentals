// 2415051059 - Syaeful Darmawan

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService _apiService;

  CourseRepository(this._apiService);

  Future<List<Course>> getCourses() async {
    return await _apiService.getCourses();
  }

  Future<Course> createCourse(Course course) async {
    return await _apiService.createCourse(course);
  }

  Future<void> updateCourse(int id, Course course) async {
    return await _apiService.updateCourse(id, course);
  }

  // Tambahan method DELETE
  Future<void> deleteCourse(int id) async {
    return await _apiService.deleteCourse(id);
  }
}