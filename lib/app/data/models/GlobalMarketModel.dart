class GlobalMarketModel {
  final double totalMarketCap;
  final double totalVolume;
  final double btcDominance;

  // Optional: previous values
  final double? previousMarketCap;
  final double? previousVolume;

  GlobalMarketModel({
    required this.totalMarketCap,
    required this.totalVolume,
    required this.btcDominance,
    this.previousMarketCap,
    this.previousVolume,
  });

  factory GlobalMarketModel.fromJson(
    Map<String, dynamic> json, {
    double? previousMarketCap,
    double? previousVolume,
  }) {
    final data = json['data'];

    return GlobalMarketModel(
      totalMarketCap:
          (data['total_market_cap']['usd'] as num?)?.toDouble() ?? 0.0,
      totalVolume: (data['total_volume']['usd'] as num?)?.toDouble() ?? 0.0,
      btcDominance:
          (data['market_cap_percentage']['btc'] as num?)?.toDouble() ?? 0.0,
      previousMarketCap: previousMarketCap,
      previousVolume: previousVolume,
    );
  }
}
