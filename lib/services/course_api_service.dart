// 2415051059 - Syaeful Darmawan

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course. HTTP ${response.statusCode}');
    }

    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        // Menyesuaikan key dengan apa yang diharapkan JSONPlaceholder
        // agar respons balikannya valid
        'userId': course.credits,
        'title': course.title,
        'body': course.code,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // Karena JSONPlaceholder tidak mengembalikan 'status', kita paksa
      // agar statusnya sesuai input form
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
}