import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';

class CoinDeskService {
  final String _baseUrl = 'data-api.coindesk.com';
  final String _path = '/news/v1/article/list';

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

    final uri = Uri.https(_baseUrl, _path, queryParams);

    final response = await _safeGet(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['Data'] ?? [];
      return results.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news (status ${response.statusCode})');
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
}

class NewsMetaService {
  /// Mengambil thumbnail dari URL berita
  Future<String?> getThumbnail(String url) async {
    if (!url.startsWith('http')) return null;

    try {
      final data = await MetadataFetch.extract(url);
      return data?.image;
    } catch (e) {
      print('Failed to fetch metadata for $url: $e');
      return null;
    }
  }
}
