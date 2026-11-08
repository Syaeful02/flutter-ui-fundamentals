// 2415051059 - Syaeful Darmawan

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role;

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isSeeker => role == 'seeker';
  bool get isOwner => role == 'owner';
  bool get isAdmin => role == 'admin';

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        email: (m['email'] as String?) ?? '',
        name: (m['name'] as String?) ?? '',
        role: (m['role'] as String?) ?? 'seeker',
      );
}