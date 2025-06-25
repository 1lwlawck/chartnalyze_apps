class UserPostStatistic {
  final int postCount;
  final int commentCount;
  final int likeCount;
  final int saveCount;

  UserPostStatistic({
    required this.postCount,
    required this.commentCount,
    required this.likeCount,
    required this.saveCount,
  });

  factory UserPostStatistic.fromJson(Map<String, dynamic> json) {
    return UserPostStatistic(
      postCount: json['post_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      saveCount: json['save_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_count': postCount,
      'comment_count': commentCount,
      'like_count': likeCount,
      'save_count': saveCount,
    };
  }
}
