class CoinModel {
  final String id;
  final String symbol;
  final double price;
  final double marketCap;
  final double change24h;
  final double change7d;
  final String icon;
  final List<double> sparkline;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.change24h,
    required this.change7d,
    required this.icon,
    required this.sparkline,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'].toUpperCase(),
      price: (json['current_price'] as num).toDouble(),
      marketCap: (json['market_cap'] as num).toDouble(),
      change24h:
          (json['price_change_percentage_24h_in_currency'] as num).toDouble(),
      change7d:
          (json['price_change_percentage_7d_in_currency'] as num).toDouble(),
      icon: json['image'],
      sparkline: List<double>.from(json['sparkline_in_7d']['price']),
    );
  }
}
