import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';

class Follow {
  final String id;
  final String followerId;
  final String followedId;
  final String createdAt;
  final UserModel? followed;
  final UserModel? follower;

  Follow({
    required this.id,
    required this.followerId,
    required this.followedId,
    required this.createdAt,
    this.followed,
    this.follower,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      id: json['id'],
      followerId: json['follower_id'],
      followedId: json['followed_id'],
      createdAt: json['created_at'],
      followed:
          json['followed'] != null
              ? UserModel.fromJson(json['followed'])
              : null,
      follower:
          json['follower'] != null
              ? UserModel.fromJson(json['follower'])
              : null,
    );
  }
}
