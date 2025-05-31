class NewsItem {
  // Informasi dasar berita
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

  // Parsing dari JSON
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      url: json['source']?['url'] ?? '',
      publishedAt: json['published_at'] ?? '',
      source: json['source']?['title'],
      thumbnail: null,
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'published_at': publishedAt,
    'thumbnail': thumbnail,
    'source': source,
  };

  // Buat salinan data dengan perubahan nilai tertentu
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

  // Konversi string waktu ke DateTime
  DateTime? get publishedDateTime {
    try {
      return DateTime.parse(publishedAt).toLocal();
    } catch (_) {
      return null;
    }
  }
}
