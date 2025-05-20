class SearchCoinModel {
  final String id;
  final String name;
  final String symbol;
  final String thumb;

  SearchCoinModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.thumb,
  });

  factory SearchCoinModel.fromJson(Map<String, dynamic> json) {
    return SearchCoinModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      thumb: json['thumb'] ?? '',
    );
  }
}
