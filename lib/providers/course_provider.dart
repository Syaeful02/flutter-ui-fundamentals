// 2415051059 - Syaeful Darmawan
// CourseProvider — mengelola async state (loading, success, error).

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository) {
    // Langsung muat data saat provider dibuat.
    loadCourses();
  }

  // ---------- STATE ----------
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _student;

  // ---------- GETTER ----------
  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get student => _student;

  // ---------- METHOD ----------
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final student = await repository.getStudent();
      final courses = await repository.getCourses();

      _student = student;
      _courses = courses;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}