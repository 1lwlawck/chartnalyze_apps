// lib/app/services/currency_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<double> fetchUsdToIdrRate() async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['rates']['idr']['value'] as num).toDouble();
    } else {
      throw Exception('Failed to fetch USD to IDR rate');
    }
  }
}
