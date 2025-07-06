import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/constants/api.dart';

class CurrencyService {
  Future<double> fetchUsdToIdrRate() async {
    final url = CoinGeckoConstants.usdToIdrRateUrl();
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['usd']['idr'] as num).toDouble();
    } else {
      throw Exception('Failed to fetch USD to IDR rate');
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
            'x-cg-demo-api-key': CoinGeckoConstants.apiKey ?? '',
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
