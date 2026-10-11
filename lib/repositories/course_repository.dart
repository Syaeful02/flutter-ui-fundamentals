// 2415051059 - Syaeful Darmawan
//
// TANGGUNG JAWAB:
// Menjadi perantara antara Provider dan Service.
// Menyembunyikan detail sumber data dari layer di atasnya.
//
// TIDAK BOLEH:
// - Mengakses rootBundle / API langsung (harus via Service)
// - Berisi Widget atau BuildContext

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