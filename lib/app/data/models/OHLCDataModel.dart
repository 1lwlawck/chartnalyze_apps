class OHLCDataModel {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  OHLCDataModel({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory OHLCDataModel.fromList(List<dynamic> entry) {
    return OHLCDataModel(
      time: DateTime.fromMillisecondsSinceEpoch(entry[0] as int),
      open: (entry[1] as num).toDouble(),
      high: (entry[2] as num).toDouble(),
      low: (entry[3] as num).toDouble(),
      close: (entry[4] as num).toDouble(),
      volume: entry.length > 5 ? (entry[5] as num).toDouble() : 0.0,
    );
  }
}
