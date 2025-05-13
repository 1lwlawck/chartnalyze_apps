// lib/app/modules/markets/controllers/markets_controller.dart

import 'dart:convert';
import 'package:chartnalyze_apps/app/data/models/CoinModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/services/crypto/CoinService.dart';
import 'package:chartnalyze_apps/app/data/models/CandleDataModel.dart';

class MarketsController extends GetxController {
  int selectedTabIndex = 0;
  var isLoading = true.obs;

  final List<String> tabLabels = [
    'Coins',
    'Stocks',
    'Watchlists',
    'Overview',
    'Exchanges',
  ];

  void changeTab(int index) {
    selectedTabIndex = index;
    update();
  }

  final CoinService _coinService = CoinService();
  List<CoinModel> coins = [];

  @override
  void onInit() {
    super.onInit();
    fetchCoinData();
  }

  Future<void> fetchCoinData() async {
    try {
      isLoading.value = true;
      final fetched = await _coinService.fetchCoins();
      coins = fetched;
    } catch (e) {
      print('Error fetching coins: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// Fetch OHLC data from CoinGecko for the given asset id (e.g. 'bitcoin').
  /// Returns a list of CandleData for the past [days] days.
  Future<List<CandleData>> fetchOHLC({
    required String id,
    int days = 7,
    String vsCurrency = 'usd',
  }) async {
    final uri = Uri.https('api.coingecko.com', '/api/v3/coins/$id/ohlc', {
      'vs_currency': vsCurrency,
      'days': days.toString(),
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load OHLC data (${res.statusCode})');
    }

    final List<dynamic> raw = json.decode(res.body);
    return raw.map((entry) {
      return CandleData(
        time: DateTime.fromMillisecondsSinceEpoch(entry[0] as int),
        open: (entry[1] as num).toDouble(),
        high: (entry[2] as num).toDouble(),
        low: (entry[3] as num).toDouble(),
        close: (entry[4] as num).toDouble(),
      );
    }).toList();
  }
}
