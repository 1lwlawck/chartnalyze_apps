import 'package:intl/intl.dart';

class UserActivity {
  final String id;
  final String userId;
  final String userAgent;
  final String userIpAddress;
  final String type;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserActivity({
    required this.id,
    required this.userId,
    required this.userAgent,
    required this.userIpAddress,
    required this.type,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    return UserActivity(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userAgent: json['user_agent'] ?? '',
      userIpAddress: json['user_ip_address'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_agent': userAgent,
      'user_ip_address': userIpAddress,
      'type': type,
      'description': description,
      'created_at': DateFormat('yyyy-MM-ddTHH:mm:ss').format(createdAt),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
