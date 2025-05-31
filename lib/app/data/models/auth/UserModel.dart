class UserModel {
  final String id;
  final String username;
  final String email;
  final String name;
  final String birthDate;
  final String createdAt;
  final String? emailVerifiedAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.birthDate,
    required this.createdAt,
    this.emailVerifiedAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      birthDate: json['birth_date'],
      createdAt: json['created_at'],
      emailVerifiedAt: json['email_verified_at'],
      updatedAt: json['updated_at'],
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      username: '',
      email: '',
      name: '',
      birthDate: '',
      createdAt: '',
      emailVerifiedAt: null,
      updatedAt: null,
    );
  }
}
