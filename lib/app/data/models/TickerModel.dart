class TickerModel {
  final String exchangeName;
  final String base;
  final String target;
  final double lastPrice;
  final double volumeUsd;
  final String trustScore;
  final String tradeUrl;
  final String exchangeUrl; // <--- tambahkan ini

  TickerModel({
    required this.exchangeName,
    required this.base,
    required this.target,
    required this.lastPrice,
    required this.volumeUsd,
    required this.trustScore,
    required this.tradeUrl,
    required this.exchangeUrl,
  });

  factory TickerModel.fromJson(Map<String, dynamic> json) {
    return TickerModel(
      exchangeName: json['market']['name'] ?? '',
      exchangeUrl:
          json['market']['identifier'] != null
              ? 'https://${json['market']['identifier']}.com'
              : '', // <--- akali jadi URL
      base: json['base'],
      target: json['target'],
      lastPrice: (json['last'] as num).toDouble(),
      volumeUsd: (json['converted_volume']['usd'] as num?)?.toDouble() ?? 0,
      trustScore: json['trust_score'] ?? '',
      tradeUrl: json['trade_url'] ?? '',
    );
  }
}
