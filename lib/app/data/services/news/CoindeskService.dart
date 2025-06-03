import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';

class CoinDeskService {
  Future<List<NewsItem>> fetchNews({
    int limit = 10,
    List<String>? categories,
    String? currencies,
  }) async {
    final queryParams = {'lang': 'EN', 'limit': '$limit'};

    if (categories != null && categories.isNotEmpty) {
      queryParams['categories'] = categories.join(',');
    }

    if (currencies != null && currencies.isNotEmpty) {
      queryParams['currencies'] = currencies;
    }

    final uri = Uri.https(
      'data-api.coindesk.com',
      '/news/v1/article/list',
      queryParams,
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['Data'] ?? [];
      return results.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news (status ${response.statusCode})');
    }
  }
}
