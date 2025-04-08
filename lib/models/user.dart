// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? major;
  final String? year;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.major,
    this.year,
  });

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      major: data['major'],
      year: data['year'],
    );
  }
}