// 2415051059 - Syaeful Darmawan

class Course {
  final String code;
  final String name;
  final int credits;
  final String status;

  const Course({
    required this.code,
    required this.name,
    required this.credits,
    required this.status,
  });

  /// Parsing dari Map JSON. Parsing dipusatkan di sini
  /// supaya UI tidak lagi akses `map['key']` langsung.
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      name: json['name'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }

  /// Helper: status badge
  bool get isSelesai => status == 'Selesai';
  bool get isSedangDipelajari => status == 'Sedang Dipelajari';
  bool get isBelum => status == 'Belum';
}