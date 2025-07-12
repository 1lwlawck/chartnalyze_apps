import 'dart:convert';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';

class CoinDeskService {
  Future<List<NewsItem>> fetchNews({
    int limit = 10,
    List<String>? categories,
    String? currencies,
  }) async {
    final uri = CoinDeskConstants.newsListUrl(
      limit: limit,
      categories: categories,
      currencies: currencies,
    );

    final response = await _safeGet(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['Data'] ?? [];
      return results.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to load news (status ${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<http.Response> _safeGet(Uri url, {int retries = 3}) async {
    int attempt = 0;
    while (attempt < retries) {
      try {
        final response = await http.get(
          url,
          headers: {
            'accept': 'application/json',
            'User-Agent': 'ChartnalyzeApp/1.0 (Flutter)',
          },
        );
        return response;
      } catch (e) {
        attempt++;
        print('Retrying... attempt $attempt');
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('Failed to fetch after $retries attempts');
  }

  Future<List<NewsItem>> searchNews(String query) async {
    final uri = CoinDeskConstants.searchNewsUrl(query: query);
    final response = await _safeGet(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['Data'] ?? [];
      return results.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search news (status ${response.statusCode})');
    }
  }
}
