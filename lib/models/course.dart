// 2415051059 - Syaeful Darmawan

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // Pemetaan dari JSONPlaceholder ke Model Course:
    // title -> title
    // body -> code (dipotong 6 karakter)
    // userId -> credits
    // status -> default 'planned'
    return Course(
      id: json['id'] as int?,
      code: json['body'] != null
          ? (json['body'] as String).substring(0, 6).toUpperCase()
          : 'UNKWN',
      title: json['title'] as String,
      credits: json['userId'] as int? ?? 0,
      status: json['status'] as String? ?? 'planned',
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