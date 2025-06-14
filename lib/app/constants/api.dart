import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiBaseUrl =
    dotenv.env['AUTH_BASE_URL'] ?? 'http://192.168.1.124:80/api';

class CoinGeckoConstants {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static final String? apiKey = dotenv.env['COINGECKO_API_KEY'];

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

  static Uri detailUrl(String id) =>
      Uri.parse('$baseUrl/coins/$id?localization=false&sparkline=true');

  static Uri ohlcUrl({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) => Uri.parse('$baseUrl/coins/$id/ohlc?vs_currency=$vsCurrency&days=$days');

  static Uri volumeUrl({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) => Uri.parse(
    '$baseUrl/coins/$id/market_chart?vs_currency=$vsCurrency&days=$days'
    '&x-cg-demo-api-key=$apiKey',
  );

  static Uri usdToIdrRateUrl() => Uri.parse(
    '$baseUrl/simple/price?ids=usd&vs_currencies=idr&x-cg-demo-api-key=$apiKey',
  );

  static Uri globalUrl() => Uri.parse('$baseUrl/global');

  static Uri searchCoinUrl(String query) =>
      Uri.parse('$baseUrl/search?query=$query&x-cg-demo-api-key=$apiKey');

  static Uri trendingUrl() =>
      Uri.parse('$baseUrl/search/trending?x-cg-demo-api-key=$apiKey');

  static Uri tickersUrl(String id, {int page = 1, int perPage = 100}) =>
      Uri.parse(
        '$baseUrl/coins/$id/tickers?page=$page&per_page=$perPage'
        '&include_exchange_logo=true&x-cg-demo-api-key=$apiKey',
      );

  static Uri exchangesUrl({int perPage = 100, int page = 1}) => Uri.parse(
    '$baseUrl/exchanges?per_page=$perPage&page=$page&x-cg-demo-api-key=$apiKey',
  );

  static Uri exchangeDetailUrl(String id) =>
      Uri.parse('$baseUrl/exchanges/$id?x-cg-demo-api-key=$apiKey');
}

class AlphaVantageConstants {
  static const String baseUrl = 'https://www.alphavantage.co/query';
  static final String? apiKey = dotenv.env['ALPHA_VANTAGE_API_KEY'];

  static Uri globalQuoteUrl({required String symbol}) =>
      Uri.parse('$baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey');

  static Uri dailyOhlcUrl({required String symbol}) => Uri.parse(
    '$baseUrl?function=TIME_SERIES_DAILY&symbol=$symbol&outputsize=compact&apikey=$apiKey',
  );
}

class FinnhubConstants {
  static const String baseUrl = 'https://finnhub.io/api/v1';
  static final String? apiKey = dotenv.env['FINNHUB_API_KEY'];

  static Uri symbolsUrl({String exchange = 'US'}) =>
      Uri.parse('$baseUrl/stock/symbol?exchange=$exchange&token=$apiKey');

  static Uri searchStockUrl(String query) =>
      Uri.parse('$baseUrl/search?q=$query&token=$apiKey');

  static Uri quoteUrl(String symbol) =>
      Uri.parse('$baseUrl/quote?symbol=$symbol&token=$apiKey');

  static Uri profileUrl(String symbol) =>
      Uri.parse('$baseUrl/stock/profile2?symbol=$symbol&token=$apiKey');
}

class AuthConstants {
  static const String loginEndpoint = '/users/login';
  static const String registerEndpoint = '/users/register';
  static const String logoutEndpoint = '/users/logout';
  static const String updateSelf = '/users/self';
  static const String updateSelfPassword = '/users/self/password';
  static const String updateSelfAvatar = '/users/self/avatar';
  static const String updateSelfEmail = '/users/self/email';
  static const String showSelf = '/users/self';
  static const String logout = '/users/self/logout';

  static String getBaseUrl() => apiBaseUrl;
}

class WatchlistConstants {
  static const String store = '/users/self/watched-assets';
  static const String index = '/users/self/watched-assets';
  static String destroy(String key) => '/users/self/watched-assets/$key';
}

class UserActivityConstants {
  static const String activitiesEndpoint = '/users';

  static Uri activitiesUrl({
    required String userId,
    int perPage = 10,
    int page = 1,
    String sort = '-created_at',
    String? type,
  }) {
    final queryParams = {
      'per_page': perPage.toString(),
      'page': page.toString(),
      'sort': sort,
    };

    if (type != null) {
      queryParams['filter[type]'] = type;
    }

    final queryString = Uri(queryParameters: queryParams).query;
    return Uri.parse(
      '$apiBaseUrl$activitiesEndpoint/$userId/activities?$queryString',
    );
  }
}
