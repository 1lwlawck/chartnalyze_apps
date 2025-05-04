import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinService {
  static const String _baseUrl =
      'https://api.coingecko.com/api/v3/coins/markets';

  Future<List<Map<String, dynamic>>> fetchCoins() async {
    final url = Uri.parse(
      '$_baseUrl?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true&price_change_percentage=24h,7d',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> coins = json.decode(response.body);

      return coins.map((coin) {
        return {
          'id': coin['id'],
          'symbol': coin['symbol'].toUpperCase(),
          'price': coin['current_price'],
          'marketCap': coin['market_cap'],
          'change': coin['price_change_percentage_24h_in_currency'],
          'change7d': coin['price_change_percentage_7d_in_currency'],
          'icon': coin['image'],
          'sparkline': List<double>.from(coin['sparkline_in_7d']['price']),
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch coins from CoinGecko');
    }
  }
}
