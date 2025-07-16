import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiBaseUrl =
    dotenv.env['AUTH_BASE_URL'] ?? 'https://backend.chartnalyze.web.id/api';

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

class CoinDeskConstants {
  static const String baseUrl = 'data-api.coindesk.com';
  static const String newsListPath = '/news/v1/article/list';
  static const String searchPath = '/news/v1/search';

  static final String? apiKey = dotenv.env['COINDESK_API_KEY'];

  static Uri newsListUrl({
    int limit = 10,
    List<String>? categories,
    String? currencies,
    String lang = 'EN',
  }) {
    final queryParams = {'lang': lang, 'limit': limit.toString()};

    if (categories != null && categories.isNotEmpty) {
      queryParams['categories'] = categories.join(',');
    }

    if (currencies != null && currencies.isNotEmpty) {
      queryParams['currencies'] = currencies;
    }

    if (apiKey != null && apiKey!.isNotEmpty) {
      queryParams['api_key'] = apiKey!;
    }

    return Uri.https(baseUrl, newsListPath, queryParams);
  }

  /// ✅ Endpoint untuk pencarian berita berdasarkan kata kunci
  static Uri searchNewsUrl({
    required String query,
    String lang = 'EN',
    String sourceKey = 'coindesk',
  }) {
    final queryParams = {
      'search_string': query,
      'lang': lang,
      'source_key': sourceKey,
    };

    if (apiKey != null && apiKey!.isNotEmpty) {
      queryParams['api_key'] = apiKey!;
    }

    return Uri.https(baseUrl, searchPath, queryParams);
  }
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

  static Uri postStatisticsUrl({required String userId}) {
    return Uri.parse('$apiBaseUrl$activitiesEndpoint/$userId/posts/statistics');
  }
}

class UserPostConstants {
  static const String baseEndpoint = '/users';

  static Uri index({
    required String userId,
    int perPage = 10,
    int page = 1,
    String sort = '-created_at',
    String? bodyFilter,
  }) {
    final queryParams = {
      'per_page': perPage.toString(),
      'page': page.toString(),
      'sort': sort,
      'join': 'user',
    };

    if (bodyFilter != null && bodyFilter.isNotEmpty) {
      queryParams['filter[body]'] = bodyFilter;
    }

    final queryString = Uri(queryParameters: queryParams).query;
    return Uri.parse('$apiBaseUrl$baseEndpoint/$userId/posts?$queryString');
  }
}

class PostConstants {
  static const String createPost = '/posts';

  static Uri show({required String postId}) {
    return Uri.parse('$apiBaseUrl/posts/$postId');
  }

  static Uri update({required String postId}) {
    return Uri.parse('$apiBaseUrl/posts/$postId');
  }

  static Uri delete({required String postId}) {
    return Uri.parse('$apiBaseUrl/posts/$postId');
  }
}

class PriceHistoryConstants {
  static const String baseEndpoint = '/price_histories';

  /// Ambil semua simbol aset yang tersedia
  static Uri symbolsUrl() {
    return Uri.parse('$apiBaseUrl$baseEndpoint/symbols');
  }

  /// Ambil histori harga dari simbol tertentu (contoh: BTC, ETH)
  static Uri historyBySymbolUrl(String symbol) {
    return Uri.parse('$apiBaseUrl$baseEndpoint/$symbol');
  }
}

class CandlestickConstants {
  static const String predictEndpoint = '/candlesticks/predict';

  static Uri predictUrl() {
    return Uri.parse('$apiBaseUrl$predictEndpoint');
  }
}
