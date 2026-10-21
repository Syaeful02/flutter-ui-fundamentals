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
  String? _error;
  
  // Data dummy sementara karena tidak pakai JSON lokal lagi
  Map<String, dynamic>? _student = {
    'name': 'Syaeful Darmawan',
    'nim': '2415051059',
    'program': 'Pendidikan Teknik Informatika',
    'university': 'Universitas Pendidikan Ganesha',
    'semester': 5,
  };

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
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
}