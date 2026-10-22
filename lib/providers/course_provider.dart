// 2415051059 - Syaeful Darmawan

import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository) {
    loadCourses();
  }

  List<Course> _courses = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  final Map<String, dynamic>? _student = {
    'name': 'Syaeful Darmawan',
    'nim': '2415051059',
    'program': 'Pendidikan Teknik Informatika',
    'university': 'Universitas Pendidikan Ganesha',
    'semester': 5,
  };

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  Map<String, dynamic>? get student => _student;

  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await repository.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCourse(Course course) async {
    _isSaving = true;
    notifyListeners();
    try {
      await repository.createCourse(course);
      await loadCourses();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // METHOD BARU UNTUK UPDATE
  Future<bool> updateCourse(Course course) async {
    if (course.id == null) {
      _error = 'ID Course tidak ditemukan';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    notifyListeners();
    try {
      await repository.updateCourse(course.id!, course);
      await loadCourses();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Tambahkan di dalam class CourseProvider

  Future<bool> deleteCourse(int id) async {
    _isSaving = true;
    notifyListeners();
    try {
      await repository.deleteCourse(id);
      await loadCourses(); // Refresh list setelah hapus
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}