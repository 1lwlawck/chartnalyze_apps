import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';

class CoinPanicService {
  Future<List<NewsItem>> fetchNews({
    String? filter,
    String? currencies,
    int page = 1,
  }) async {
    final url = CryptoPanicConstants.postsUrl(
      filter: filter,
      currencies: currencies,
      page: page,
      approved: true,
      public: true,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'] ?? [];

      return results.map((jsonItem) => NewsItem.fromJson(jsonItem)).toList();
    } else {
      throw Exception(
        '❌ Failed to load news from CryptoPanic (status ${response.statusCode})',
      );
    }
  }
}
