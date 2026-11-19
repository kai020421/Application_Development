class AppUserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' | 'admin'

  const AppUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory AppUserModel.fromMap(String uid, Map<String, dynamic> data) {
    return AppUserModel(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'student',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}