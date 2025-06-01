class UserModel {
  final String id;
  final String username;
  final String email;
  final String? name;
  final String? birthDate;
  final String? createdAt;
  final String? emailVerifiedAt;
  final String? updatedAt;
  final String? avatarUrl;
  final Role? role;
  final Country? country;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.birthDate,
    this.createdAt,
    this.emailVerifiedAt,
    this.updatedAt,
    this.avatarUrl,
    this.role,
    this.country,
  });

  // Factory constructor to create an empty UserModel
  factory UserModel.empty() {
    return UserModel(
      id: '',
      username: '',
      email: '',
      name: null,
      birthDate: null,
      createdAt: null,
      emailVerifiedAt: null,
      updatedAt: null,
      avatarUrl: null,
      role: null,
      country: null,
    );
  }

  // === SAFE GETTER ===

  String get formattedCreatedAt {
    final dt = DateTime.tryParse(createdAt ?? '');
    if (dt == null) return 'Join date unknown';
    return 'Joined in ${_monthName(dt.month)} ${dt.year}';
  }

  String get formattedBirthDate {
    final dt = DateTime.tryParse(birthDate ?? '');
    if (dt == null) return '-';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String get formattedEmailVerified {
    final dt = DateTime.tryParse(emailVerifiedAt ?? '');
    if (dt == null) return 'Not verified';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  // === HELPER ===
  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  // === JSON PARSER ===
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      birthDate: json['birth_date'],
      createdAt: json['created_at'],
      emailVerifiedAt: json['email_verified_at'],
      updatedAt: json['updated_at'],
      avatarUrl: json['avatar_url'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
    );
  }
}

class Role {
  final String id;
  final String name;
  Role({required this.id, required this.name});
  factory Role.fromJson(Map<String, dynamic> json) =>
      Role(id: json['id'], name: json['name']);
}

class Country {
  final String id;
  final String name;
  final String isoCode;
  Country({required this.id, required this.name, required this.isoCode});
  factory Country.fromJson(Map<String, dynamic> json) =>
      Country(id: json['id'], name: json['name'], isoCode: json['iso_code']);
}
