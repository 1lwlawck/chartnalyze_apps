class FinnhubQuoteModel {
  final double currentPrice;
  final double high;
  final double low;
  final double open;
  final double previousClose;
  final String? symbol;
  final String? name;
  final String? logo;
  final List<double> sparkline;

  FinnhubQuoteModel({
    required this.currentPrice,
    required this.high,
    required this.low,
    required this.open,
    required this.previousClose,
    this.symbol,
    this.name,
    this.logo,
    this.sparkline = const [],
  });

  FinnhubQuoteModel copyWith({
    String? symbol,
    String? name,
    String? logo,
    List<double>? sparkline,
  }) {
    return FinnhubQuoteModel(
      currentPrice: currentPrice,
      high: high,
      low: low,
      open: open,
      previousClose: previousClose,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      sparkline: sparkline ?? this.sparkline,
    );
  }

  factory FinnhubQuoteModel.fromJson(Map<String, dynamic> json) {
    return FinnhubQuoteModel(
      currentPrice: (json['c'] ?? 0).toDouble(),
      high: (json['h'] ?? 0).toDouble(),
      low: (json['l'] ?? 0).toDouble(),
      open: (json['o'] ?? 0).toDouble(),
      previousClose: (json['pc'] ?? 0).toDouble(),
    );
  }
}
