// lib/app/services/coin_panic_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinPanicService {
  final String _apiKey = '740d524ea774623286008b92dc14679ff253c3a9';

  Future<List<dynamic>> fetchTrendingNews() async {
    final url = Uri.parse(
        'https://cryptopanic.com/api/v1/posts/?auth_token=$_apiKey&filter=trending');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load news from CryptoPanic');
    }
  }
}
