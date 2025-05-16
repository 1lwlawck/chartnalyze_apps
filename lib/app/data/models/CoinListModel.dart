class CoinListModel {
  final String id;
  final int rank;
  final String symbol;
  final String name;
  final double price;
  final double marketCap;
  final double change24h;
  final double change7d;
  final String icon;
  final List<double> sparkline;

  CoinListModel({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.price,
    required this.marketCap,
    required this.change24h,
    required this.change7d,
    required this.icon,
    required this.sparkline,
  });

  factory CoinListModel.fromJson(Map<String, dynamic> json) {
    return CoinListModel(
      id: json['id'],
      rank:
          json['market_cap_rank'] != null
              ? json['market_cap_rank'] as int
              : 9999,

      name: json['name'] ?? '',
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      price: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      change24h:
          (json['price_change_percentage_24h_in_currency'] as num?)
              ?.toDouble() ??
          0.0,
      change7d:
          (json['price_change_percentage_7d_in_currency'] as num?)
              ?.toDouble() ??
          0.0,
      icon: json['image'] ?? '',
      sparkline:
          json['sparkline_in_7d'] != null &&
                  json['sparkline_in_7d']['price'] != null
              ? List<double>.from(
                (json['sparkline_in_7d']['price'] as List).map(
                  (e) => (e as num).toDouble(),
                ),
              )
              : [],
    );
  }
}
