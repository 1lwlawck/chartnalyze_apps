class CandleData {
  /// Waktu candlestick (biasanya timestamp dari API)
  final DateTime time;

  /// Harga buka
  final double open;

  /// Harga tertinggi
  final double high;

  /// Harga terendah
  final double low;

  /// Harga tutup
  final double close;

  CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  /// Factory constructor untuk membuat dari list API OHLC:
  /// [0] = timestamp (ms), [1] = open, [2] = high, [3] = low, [4] = close
  factory CandleData.fromList(List<dynamic> entry) {
    return CandleData(
      time: DateTime.fromMillisecondsSinceEpoch(entry[0] as int),
      open: (entry[1] as num).toDouble(),
      high: (entry[2] as num).toDouble(),
      low: (entry[3] as num).toDouble(),
      close: (entry[4] as num).toDouble(),
    );
  }
}
