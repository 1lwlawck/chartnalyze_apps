class NewsItem {
  final String title;
  final String url;
  final String publishedAt;
  final String? thumbnail;

  NewsItem({
    required this.title,
    required this.url,
    required this.publishedAt,
    this.thumbnail,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'],
      url: json['url'],
      publishedAt: json['published_at'],
      thumbnail: null, // Diisi nanti dari NewsMetaService
    );
  }
}
