class TickerModel {
  final String marketName;
  final String base;
  final String target;
  final double price;
  final double volume;
  final String trustScore;
  final String tradeUrl;
  final String exchangeLogo;

  TickerModel({
    required this.marketName,
    required this.base,
    required this.target,
    required this.price,
    required this.volume,
    required this.trustScore,
    required this.tradeUrl,
    required this.exchangeLogo,
  });

  factory TickerModel.fromJson(Map<String, dynamic> json) {
    return TickerModel(
      marketName: json['market']['name'] ?? '',
      exchangeLogo:
          json['market']['logo'] ?? '', // Logo exchange diambil dari sini
      base: json['base'] ?? '',
      target: json['target'] ?? '',
      price: (json['last'] as num).toDouble(),
      volume: (json['converted_volume']['usd'] as num?)?.toDouble() ?? 0,
      trustScore: json['trust_score'] ?? '',
      tradeUrl: json['trade_url'] ?? '',
    );
  }
}
