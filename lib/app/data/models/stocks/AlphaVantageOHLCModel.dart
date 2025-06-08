class AlphaVantageOHLC {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  AlphaVantageOHLC({
    required this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory AlphaVantageOHLC.fromJson(String dateKey, Map<String, dynamic> data) {
    return AlphaVantageOHLC(
      date: DateTime.parse(dateKey),
      open: double.tryParse(data['1. open'] ?? '0') ?? 0,
      high: double.tryParse(data['2. high'] ?? '0') ?? 0,
      low: double.tryParse(data['3. low'] ?? '0') ?? 0,
      close: double.tryParse(data['4. close'] ?? '0') ?? 0,
    );
  }
}
