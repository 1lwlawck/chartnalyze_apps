class CoinDetailModel {
  final String id;
  final String name;
  final String symbol;
  final String description;
  final String hashingAlgorithm;
  final int blockTime;
  final String genesisDate;
  final String imageUrl;
  final String homepage;
  final String explorer;
  final String whitepaper;
  final List<String> categories;

  // Tambahan dari CoinModel
  final double price;
  final double priceIdr;
  final double marketCap;
  final int rank;
  final double change24h;
  final double change7d;
  final double change30d;
  final double totalVolume;
  final double? totalSupply;
  final double? circulatingSupply;
  final double high24h;
  final double low24h;
  final List<double> sparkline;

  CoinDetailModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.description,
    required this.hashingAlgorithm,
    required this.blockTime,
    required this.genesisDate,
    required this.imageUrl,
    required this.homepage,
    required this.explorer,
    required this.whitepaper,
    required this.categories,
    // Tambahan dari CoinModel
    required this.price,
    required this.priceIdr,
    required this.marketCap,
    required this.rank,
    required this.change24h,
    required this.change7d,
    required this.change30d,
    required this.totalVolume,
    required this.totalSupply,
    required this.circulatingSupply,
    required this.high24h,
    required this.low24h,
    required this.sparkline,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    return CoinDetailModel(
      id: json['id'],
      name: json['name'],
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      description: json['description']['en'] ?? '',
      hashingAlgorithm: json['hashing_algorithm'] ?? '-',
      blockTime: json['block_time_in_minutes'] ?? 0,
      genesisDate: json['genesis_date'] ?? '-',
      imageUrl: json['image']['small'] ?? '',
      homepage:
          json['links']['homepage'].isNotEmpty
              ? json['links']['homepage'][0]
              : '',
      explorer:
          json['links']['blockchain_site'].isNotEmpty
              ? json['links']['blockchain_site'][0]
              : '',
      whitepaper: json['links']['whitepaper'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),

      // Fields from CoinModel
      price:
          (json['market_data']?['current_price']?['usd'] as num?)?.toDouble() ??
          0.0,
      priceIdr:
          (json['market_data']?['current_price']?['idr'] as num?)?.toDouble() ??
          0.0,
      marketCap:
          (json['market_data']?['market_cap']?['usd'] as num?)?.toDouble() ??
          0.0,
      rank: json['market_cap_rank'] ?? 0,
      change24h:
          (json['market_data']?['price_change_percentage_24h'] as num?)
              ?.toDouble() ??
          0.0,
      change7d:
          (json['market_data']?['price_change_percentage_7d'] as num?)
              ?.toDouble() ??
          0.0,
      change30d:
          (json['market_data']?['price_change_percentage_30d'] as num?)
              ?.toDouble() ??
          0.0,
      totalVolume:
          (json['market_data']?['total_volume']?['usd'] as num?)?.toDouble() ??
          0.0,
      totalSupply: (json['market_data']?['total_supply'] as num?)?.toDouble(),
      circulatingSupply:
          (json['market_data']?['circulating_supply'] as num?)?.toDouble(),
      high24h:
          (json['market_data']?['high_24h']?['usd'] as num?)?.toDouble() ?? 0.0,
      low24h:
          (json['market_data']?['low_24h']?['usd'] as num?)?.toDouble() ?? 0.0,
      sparkline:
          json['market_data']?['sparkline_7d']?['price'] != null
              ? List<double>.from(
                (json['market_data']!['sparkline_7d']!['price'] as List).map(
                  (e) => (e as num).toDouble(),
                ),
              )
              : [],
    );
  }
}
