class WatchedAssetModel {
  final String key;
  final String name;
  final String symbol;
  final String imageUrl;

  WatchedAssetModel({
    required this.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
  });

  factory WatchedAssetModel.fromJson(Map<String, dynamic> json) {
    return WatchedAssetModel(
      key: json['key'],
      name: json['name'],
      symbol: json['symbol'],
      imageUrl: json['image_url'],
    );
  }
}
