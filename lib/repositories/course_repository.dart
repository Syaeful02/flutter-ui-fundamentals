// 2415051059 - Syaeful Darmawan

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService _apiService;

  CourseRepository(this._apiService);

  Future<List<Course>> getCourses() async {
    return await _apiService.getCourses();
  }
}