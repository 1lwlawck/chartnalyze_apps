class GlobalMarketModel {
  // Data pasar global saat ini
  final double totalMarketCap;
  final double totalVolume;
  final double btcDominance;

  // Data sebelumnya (opsional)
  final double? previousMarketCap;
  final double? previousVolume;

  // Konstruktor
  GlobalMarketModel({
    required this.totalMarketCap,
    required this.totalVolume,
    required this.btcDominance,
    this.previousMarketCap,
    this.previousVolume,
  });

  // Konversi dari JSON ke model
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
