// 2415051059 - Syaeful Darmawan

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? ownerId; // <-- TAMBAHKAN INI

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.ownerId, // <-- TAMBAHKAN INI
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String? ?? 'UNKNOWN',
      title: json['title'] as String? ?? 'Tanpa Judul',
      credits: json['credits'] as int? ?? 0,
      status: json['status'] as String? ?? 'planned',
      ownerId: json['owner_id'] as String?, // <-- TAMBAHKAN INI
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
}