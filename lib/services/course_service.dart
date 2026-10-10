// 2415051059 - Syaeful DarmawanK

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    final raw = await rootBundle.loadString('assets/data/student_data.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Membaca data student (identitas mahasiswa).
  Future<Map<String, dynamic>> loadStudent() async {
    final raw = await rootBundle.loadString('assets/data/student_data.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    return data['student'] as Map<String, dynamic>;
  }
}