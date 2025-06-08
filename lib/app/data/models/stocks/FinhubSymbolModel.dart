class FinnhubSymbolModel {
  final String symbol;
  final String displaySymbol;
  final String description;

  FinnhubSymbolModel({
    required this.symbol,
    required this.displaySymbol,
    required this.description,
  });

  factory FinnhubSymbolModel.fromJson(Map<String, dynamic> json) {
    return FinnhubSymbolModel(
      symbol: json['symbol'] ?? '',
      displaySymbol: json['displaySymbol'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
