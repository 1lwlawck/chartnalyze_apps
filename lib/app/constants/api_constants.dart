class CoinGeckoConstants {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const String apiKey = 'CG-AejYWkdQoDFRRQouj2xuZQ1S';

  static const String marketEndpoint = '/coins/markets';
  static const String detailEndpoint = '/coins';
  static const String ohlcEndpoint = '/coins/{id}/ohlc';

  // https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=true&price_change_percentage=1h,24h,7d,30d
  // for coin list in USD currency with pagination and sparkline data in USD
  static Uri marketUrl({
    String vsCurrency = 'usd',
    int page = 1,
    int perPage = 25,
  }) {
    return Uri.parse(
      '$baseUrl/coins/markets'
      '?vs_currency=$vsCurrency'
      '&order=market_cap_desc'
      '&per_page=$perPage'
      '&page=$page'
      '&sparkline=true'
      '&price_change_percentage=1h,24h,7d,30d'
      '&x-cg-demo-api-key=$apiKey',
    );
  }

  // https://api.coingecko.com/api/v3/coins/{id}?localization=false&sparkline=true
  // for coin detail
  static Uri detailUrl(String id) {
    return Uri.parse(
      '$baseUrl$detailEndpoint/$id?localization=false&sparkline=true',
    );
  }

  // https://api.coingecko.com/api/v3/coins/{id}/ohlc
  // for OHLC data in USD currency
  static Uri ohlcUrl({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) {
    return Uri.parse(
      '$baseUrl/coins/$id/ohlc?vs_currency=$vsCurrency&days=$days',
    );
  }

  // https://api.coingecko.com/api/v3/coins/{id}/market_chart
  // for volume data in USD currency
  static Uri volumeUrl({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) {
    return Uri.parse(
      '$baseUrl/coins/$id/market_chart?vs_currency=$vsCurrency&days=$days'
      '&x-cg-demo-api-key=$apiKey',
    );
  }

  // https://api.coingecko.com/api/v3/simple/price?ids=usd&vs_currencies=idr
  // for USD to IDR rate
  static Uri usdToIdrRateUrl() {
    return Uri.parse(
      '$baseUrl/simple/price?ids=usd&vs_currencies=idr&x-cg-demo-api-key=$apiKey',
    );
  }
}

// https://cryptopanic.com/api/v1/posts/?auth_token=740d524ea774623286008b92dc14679ff253c3a9
// for CryptoPanic news
class CryptoPanicConstants {
  static const String cryptopanicAPI = 'https://cryptopanic.com/api/v1';
  static const String trendingEndpoint = '/posts/';
  static const String apiKey = '740d524ea774623286008b92dc14679ff253c3a9';
}
