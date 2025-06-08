class AlphaVantageQuoteModel {
  final String symbol;
  final double price;
  final double open;
  final double high;
  final double low;
  final double previousClose;
  final String latestTradingDay;

  AlphaVantageQuoteModel({
    required this.symbol,
    required this.price,
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
    required this.latestTradingDay,
  });

  factory AlphaVantageQuoteModel.fromJson(Map<String, dynamic> json) {
    final data = json['Global Quote'] ?? {};
    return AlphaVantageQuoteModel(
      symbol: data['01. symbol'] ?? '',
      price: double.tryParse(data['05. price'] ?? '0') ?? 0,
      open: double.tryParse(data['02. open'] ?? '0') ?? 0,
      high: double.tryParse(data['03. high'] ?? '0') ?? 0,
      low: double.tryParse(data['04. low'] ?? '0') ?? 0,
      previousClose: double.tryParse(data['08. previous close'] ?? '0') ?? 0,
      latestTradingDay: data['07. latest trading day'] ?? '',
    );
  }
}
