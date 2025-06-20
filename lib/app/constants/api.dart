import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinGeckoConstants {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static final String? apiKey = dotenv.env['COINGECKO_API_KEY'];

  static const String marketEndpoint = '/coins/markets';
  static const String detailEndpoint = '/coins';
  static const String ohlcEndpoint = '/coins/{id}/ohlc';
  static const String globalEndpoint = '/global';

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

  static Uri globalUrl() {
    return Uri.parse('$baseUrl$globalEndpoint');
  }

  // https://api.coingecko.com/api/v3/search?query=btc
  static Uri searchCoinUrl(String query) {
    return Uri.parse('$baseUrl/search?query=$query&x-cg-demo-api-key=$apiKey');
  }

  static Uri trendingUrl() {
    return Uri.parse('$baseUrl/search/trending?x-cg-demo-api-key=$apiKey');
  }

  static Uri tickersUrl(String id, {int page = 1, int perPage = 100}) {
    return Uri.parse(
      '$baseUrl/coins/$id/tickers'
      '?page=$page&per_page=$perPage'
      '&include_exchange_logo=true'
      '&x-cg-demo-api-key=$apiKey',
    );
  }

  static Uri exchangesUrl({int perPage = 100, int page = 1}) {
    return Uri.parse(
      '$baseUrl/exchanges?per_page=$perPage&page=$page'
      '&x-cg-demo-api-key=$apiKey',
    );
  }

  static Uri exchangeDetailUrl(String id) {
    return Uri.parse('$baseUrl/exchanges/$id?x-cg-demo-api-key=$apiKey');
  }
}

class AlphaVantageConstants {
  static const String baseUrl = 'https://www.alphavantage.co/query';
  static final String? apiKey = dotenv.env['ALPHA_VANTAGE_API_KEY'];

  // Global Quote endpoint
  static Uri globalQuoteUrl({required String symbol}) {
    return Uri.parse(
      '$baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey',
    );
  }

  // Daily OHLC endpoint
  static Uri dailyOhlcUrl({required String symbol}) {
    return Uri.parse(
      '$baseUrl?function=TIME_SERIES_DAILY&symbol=$symbol&outputsize=compact&apikey=$apiKey',
    );
  }
}

class FinnhubConstants {
  static const String baseUrl = 'https://finnhub.io/api/v1';
  static final String? apiKey = dotenv.env['FINNHUB_API_KEY'];

  // List semua saham di US
  static Uri symbolsUrl({String exchange = 'US'}) {
    return Uri.parse('$baseUrl/stock/symbol?exchange=$exchange&token=$apiKey');
  }

  // Search saham berdasarkan nama atau simbol
  static Uri searchStockUrl(String query) {
    return Uri.parse('$baseUrl/search?q=$query&token=$apiKey');
  }

  // Real-time quote (opsional Finnhub juga bisa)
  static Uri quoteUrl(String symbol) {
    print("Making quote URL for $symbol with token: $apiKey");
    return Uri.parse('$baseUrl/quote?symbol=$symbol&token=$apiKey');
  }
}

// https://cryptopanic.com/api/v1/posts/?auth_token=740d524ea774623286008b92dc14679ff253c3a9
// for CryptoPanic news
// class CryptoPanicConstants {
//   static const String baseUrl = 'https://cryptopanic.com/api/developer/v2';
//   static final String? apiKey = dotenv.env['CRYPTOPANIC_API_KEY'];

//   static const String postsEndpoint = '/posts/';
//   static const String portfolioEndpoint = '/portfolio/';
//   static const String rssEndpoint = '/news/rss/';

//   /// URL builder untuk ambil berita
//   static Uri postsUrl({
//     String? filter, // e.g. trending, bullish, bearish, important, etc.
//     String? currencies, // e.g. BTC,ETH
//     String? regions, // e.g. en,de,cn
//     String? kind, // e.g. news, media
//     bool public = true,
//     bool following = false,
//     bool approved = true,
//     int page = 1,
//   }) {
//     final params = <String, String>{
//       'auth_token': apiKey ?? '',
//       'public': public.toString(),
//       'approved': approved.toString(),
//       'page': page.toString(),
//     };

//     if (filter != null) params['filter'] = filter;
//     if (currencies != null) params['currencies'] = currencies;
//     if (regions != null) params['regions'] = regions;
//     if (kind != null) params['kind'] = kind;
//     if (following) params['following'] = 'true';

//     final queryString = Uri(queryParameters: params).query;
//     return Uri.parse('$baseUrl$postsEndpoint?$queryString');
//   }

//   /// Portfolio API (private only)
//   static Uri portfolioUrl() {
//     return Uri.parse('$baseUrl$portfolioEndpoint?auth_token=$apiKey');
//   }

//   /// RSS Format URL (optional)
//   static Uri rssFeedUrl({String? currencies, String? filter}) {
//     final params = <String, String>{
//       'auth_token': apiKey ?? '',
//       'format': 'rss',
//     };

//     if (currencies != null) params['currencies'] = currencies;
//     if (filter != null) params['filter'] = filter;

//     final queryString = Uri(queryParameters: params).query;
//     return Uri.parse('$baseUrl$postsEndpoint?$queryString');
//   }
// }

class AuthConstants {
  /// Base URL for the backend API
  /// Uses [AUTH_BASE_URL] from the environment if available
  static final String baseUrl =
      dotenv.env['AUTH_BASE_URL'] ?? 'http://192.168.69.214:80/api';

  static const String loginEndpoint = '/users/login';
  static const String registerEndpoint = '/users/register';
  static const String logoutEndpoint = '/users/logout';
  static const String updateSelf = '/users/self';
  static const String updateSelfPassword = '/users/self/password';
  static const String updateSelfAvatar = '/users/self/avatar';
  static const String updateSelfEmail = '/users/self/email';
  static const String showSelf = '/users/self';
  static const String logout = '/users/self/logout';
}

class WatchlistConstants {
  static const String store = '/users/self/watched-assets';
  static const String index = '/users/self/watched-assets';
  static String destroy(String key) => '/users/self/watched-assets/$key';
}
