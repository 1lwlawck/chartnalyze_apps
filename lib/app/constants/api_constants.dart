class CoinGeckoConstants {
  static const String coingeckoAPI = 'https://api.coingecko.com/api/v3';
  static const String marketEndpoint = '/coins/markets';
  static const String vsCurrency = 'usd';
  static const int perPage = 20;
  static const String order = 'market_cap_desc';
  static const String priceChange = '24h,7d';
}

class CryptoPanicConstants {
  static const String cryptopanicAPI = 'https://cryptopanic.com/api/v1';
  static const String trendingEndpoint = '/posts/';
  static const String apiKey = '740d524ea774623286008b92dc14679ff253c3a9';
}
