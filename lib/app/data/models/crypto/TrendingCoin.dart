class TrendingCoin {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double priceChange24h;

  TrendingCoin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.priceChange24h,
  });

  factory TrendingCoin.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final change = data['price_change_percentage_24h']?['usd'];

    return TrendingCoin(
      id: json['id'] ?? '',
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['large'] ?? json['thumb'] ?? '',
      priceChange24h: (change is num) ? change.toDouble() : 0.0,
    );
  }
}
