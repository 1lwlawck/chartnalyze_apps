import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/constants/api_constants.dart';

class CoinPanicService {
  Future<List<dynamic>> fetchTrendingNews() async {
    final url = Uri.parse(
      '${CryptoPanicConstants.cryptopanicAPI}${CryptoPanicConstants.trendingEndpoint}'
      '?auth_token=${CryptoPanicConstants.apiKey}&filter=trending',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Failed to load news from CryptoPanic');
    }
  }
}
