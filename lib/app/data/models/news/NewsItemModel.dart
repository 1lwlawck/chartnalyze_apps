class NewsItem {
  final String title;
  final String url;
  final String publishedAt;
  final String? thumbnail;
  final String? source;
  final String? body;
  final String? sentiment;
  final List<String>? categories;

  NewsItem({
    required this.title,
    required this.url,
    required this.publishedAt,
    this.thumbnail,
    this.source,
    this.body,
    this.sentiment,
    this.categories,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['TITLE'] ?? '',
      url: json['URL'] ?? '',
      publishedAt:
          DateTime.fromMillisecondsSinceEpoch(
            (json['PUBLISHED_ON'] ?? 0) * 1000,
          ).toIso8601String(),
      thumbnail: json['IMAGE_URL'],
      source: json['SOURCE_DATA']?['NAME'] ?? 'Unknown Source',
      body: json['BODY'],
      sentiment: json['SENTIMENT'],
      categories:
          (json['CATEGORY_DATA'] as List<dynamic>?)
              ?.map((cat) => cat['CATEGORY']?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'published_at': publishedAt,
    'thumbnail': thumbnail,
    'source': source,
    'body': body,
    'sentiment': sentiment,
    'categories': categories,
  };

  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedAt).toLocal();
    } catch (_) {
      return null;
    }
  }
}
