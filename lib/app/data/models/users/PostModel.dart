class PostModel {
  final String id;
  final String userId;
  final String? title;
  final String slug;
  final String body;
  final String createdAt;
  final String? updatedAt;
  final int commentCount;
  final int likeCount;
  final List<String> imageUrls;

  PostModel({
    required this.id,
    required this.userId,
    this.title,
    required this.slug,
    required this.body,
    required this.createdAt,
    this.updatedAt,
    required this.commentCount,
    required this.likeCount,
    required this.imageUrls,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      slug: json['slug'],
      body: json['body'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      commentCount: json['comment_count'],
      likeCount: json['like_count'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
    );
  }
}
