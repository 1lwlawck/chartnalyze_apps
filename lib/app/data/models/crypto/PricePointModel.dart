class PricePoint {
  final String symbol;
  final double price;
  final DateTime scrapedAt;

  PricePoint({
    required this.symbol,
    required this.price,
    required this.scrapedAt,
  });

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      symbol: json['symbol'] ?? '',
      price: double.parse(json['price_usd'].toString()),
      scrapedAt: DateTime.parse(json['scraped_at']['\$date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'price_usd': price,
      'scraped_at': {'\$date': scrapedAt.toIso8601String()},
    };
  }

  // Optional: jika kamu ingin copyWith
  PricePoint copyWith({String? symbol, double? price, DateTime? scrapedAt}) {
    return PricePoint(
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      scrapedAt: scrapedAt ?? this.scrapedAt,
    );
  }
}
