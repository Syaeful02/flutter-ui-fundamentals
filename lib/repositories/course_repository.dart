// 2415051059 - Syaeful Darmawan

import '../models/course.dart';
import '../services/course_data_source.dart'; // <-- Ganti import

class CourseRepository {
  // Gunakan abstraksi, bukan class konkret
  final CourseDataSource _dataSource;

  CourseRepository(this._dataSource);

  Future<List<Course>> getCourses() => _dataSource.getCourses();
  Future<Course> createCourse(Course course) => _dataSource.createCourse(course);
  Future<void> updateCourse(int id, Course course) => _dataSource.updateCourse(id, course);
  Future<void> deleteCourse(int id) => _dataSource.deleteCourse(id);
}