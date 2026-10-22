// 2415051059 - Syaeful Darmawan

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import 'course_data_source.dart'; // <-- Tambah import

// Implementasikan interface
class CourseApiService implements CourseDataSource {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  @override
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course. HTTP ${response.statusCode}');
    }
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'userId': course.credits,
        'title': course.title,
        'body': course.code,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Course(
        id: data['id'] as int?,
        code: course.code,
        title: course.title,
        credits: course.credits,
        status: course.status,
      );
    } else {
      throw Exception('Gagal membuat course. HTTP ${response.statusCode}');
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': id,
        'userId': course.credits,
        'title': course.title,
        'body': course.code,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal update course. HTTP ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal menghapus course. HTTP ${response.statusCode}');
    }
  }
}