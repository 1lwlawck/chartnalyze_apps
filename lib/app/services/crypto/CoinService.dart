import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/data/models/CoinModel.dart';
import 'package:chartnalyze_apps/app/constants/api_constants.dart';

class CoinService {
  Future<List<CoinModel>> fetchCoins() async {
    final url = Uri.parse(
      '${CoinGeckoConstants.coingeckoAPI}${CoinGeckoConstants.marketEndpoint}'
      '?vs_currency=${CoinGeckoConstants.vsCurrency}'
      '&order=${CoinGeckoConstants.order}'
      '&per_page=${CoinGeckoConstants.perPage}'
      '&page=1'
      '&sparkline=true'
      '&price_change_percentage=${CoinGeckoConstants.priceChange}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      // Convert each map to CoinModel
      return jsonList.map((e) => CoinModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch coins');
    }
  }
}
