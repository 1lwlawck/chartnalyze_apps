class ExchangeModel {
  final String id;
  final String name;
  final int? yearEstablished;
  final String? country;
  final String? description;
  final String url;
  final String image;
  final bool hasTradingIncentive;
  final int trustScore;
  final int trustScoreRank;
  final double tradeVolume24hBtc;
  final double tradeVolume24hBtcNormalized;

  ExchangeModel({
    required this.id,
    required this.name,
    this.yearEstablished,
    this.country,
    this.description,
    required this.url,
    required this.image,
    required this.hasTradingIncentive,
    required this.trustScore,
    required this.trustScoreRank,
    required this.tradeVolume24hBtc,
    required this.tradeVolume24hBtcNormalized,
  });

  factory ExchangeModel.fromJson(Map<String, dynamic> json) {
    return ExchangeModel(
      id: json['id'],
      name: json['name'],
      yearEstablished: json['year_established'],
      country: json['country'],
      description: json['description'],
      url: json['url'],
      image: json['image'],
      hasTradingIncentive: json['has_trading_incentive'] ?? false,
      trustScore: json['trust_score'] ?? 0,
      trustScoreRank: json['trust_score_rank'] ?? 0,
      tradeVolume24hBtc:
          (json['trade_volume_24h_btc'] as num?)?.toDouble() ?? 0.0,
      tradeVolume24hBtcNormalized:
          (json['trade_volume_24h_btc_normalized'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
