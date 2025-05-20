class NewsItem {
  final String title;
  final String url;
  final String publishedAt;
  final String? thumbnail;
  final String? source;

  NewsItem({
    required this.title,
    required this.url,
    required this.publishedAt,
    this.thumbnail,
    this.source,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      url: json['source']?['url'] ?? '',
      publishedAt: json['published_at'] ?? '',
      source: json['source']?['title'],
      thumbnail: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'published_at': publishedAt,
    'thumbnail': thumbnail,
    'source': source,
  };

  NewsItem copyWith({
    String? title,
    String? url,
    String? publishedAt,
    String? thumbnail,
    String? source,
  }) {
    return NewsItem(
      title: title ?? this.title,
      url: url ?? this.url,
      publishedAt: publishedAt ?? this.publishedAt,
      thumbnail: thumbnail ?? this.thumbnail,
      source: source ?? this.source,
    );
  }

  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedAt).toLocal();
    } catch (_) {
      return null;
    }
  }
}
