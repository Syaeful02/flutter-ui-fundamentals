// 2415051059 - Syaeful Darmawan

import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService _service;

  CourseRepository(this._service);

  /// Ambil daftar course. Saat ini delegasi ke Service (asset JSON).
  /// Kalau nanti pindah ke API, method ini bisa diubah tanpa menyentuh
  /// Provider atau UI.
  Future<List<Course>> getCourses() async {
    return await _service.loadCourses();
  }

  /// Ambil data mahasiswa.
  Future<Map<String, dynamic>> getStudent() async {
    return await _service.loadStudent();
  }
}