import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/ExchangeModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/GlobalMarketModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/OHLCDataModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/SearchCoinModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TrendingCoin.dart';

class CoinService {
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

  Future<List<CoinListModel>> fetchCoinListData({
    String vsCurrency = 'usd',
    int page = 1,
    int perPage = 20,
  }) async {
    final url = CoinGeckoConstants.marketUrl(
      vsCurrency: vsCurrency,
      page: page,
      perPage: perPage,
    );
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => CoinListModel.fromJson(e)).toList();
    } else {
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  Future<CoinDetailModel> fetchCoinDetail(String id) async {
    final url = CoinGeckoConstants.detailUrl(id);
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return CoinDetailModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to fetch detail for $id');
    }
  }

  Future<List<List<dynamic>>> fetchOhlcRaw({
    required String coinId,
    required int days,
    String vsCurrency = 'usd',
  }) async {
    final url = CoinGeckoConstants.ohlcUrl(
      id: coinId,
      vsCurrency: vsCurrency,
      days: days,
    );

    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      return List<List<dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load OHLC raw data');
    }
  }

  Future<List<List<dynamic>>> fetchVolumeRaw({
    required String coinId,
    required int days,
    String vsCurrency = 'usd',
  }) async {
    final url = CoinGeckoConstants.volumeUrl(
      id: coinId,
      vsCurrency: vsCurrency,
      days: days,
    );

    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return List<List<dynamic>>.from(body['total_volumes']);
    } else {
      throw Exception('Failed to load volume data');
    }
  }

  Future<List<OHLCDataModel>> fetchOhlcData({
    required String coinId,
    String vsCurrency = 'usd',
    int days = 1,
  }) async {
    final ohlcRaw = await fetchOhlcRaw(
      coinId: coinId,
      days: days,
      vsCurrency: vsCurrency,
    );
    final volumeRaw = await fetchVolumeRaw(
      coinId: coinId,
      days: days,
      vsCurrency: vsCurrency,
    );

    return ohlcRaw.map((entry) {
      final timestamp = entry[0] as int;
      final volume =
          volumeRaw.firstWhere(
            (v) => (v[0] - timestamp).abs() < 30 * 60 * 1000,
            orElse: () => [timestamp, 0.0],
          )[1];

      return OHLCDataModel(
        time: DateTime.fromMillisecondsSinceEpoch(timestamp),
        open: (entry[1] as num).toDouble(),
        high: (entry[2] as num).toDouble(),
        low: (entry[3] as num).toDouble(),
        close: (entry[4] as num).toDouble(),
        volume: (volume as num).toDouble(),
      );
    }).toList();
  }

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

  Future<GlobalMarketModel> fetchGlobalMarketModel({
    double? previousMarketCap,
    double? previousVolume,
  }) async {
    final url = CoinGeckoConstants.globalUrl();
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return GlobalMarketModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to fetch global market data');
    }
  }

  Future<List<SearchCoinModel>> searchCoins(String query) async {
    final url = CoinGeckoConstants.searchCoinUrl(query);
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coins = data['coins'];
      return coins.map((e) => SearchCoinModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search coins from CoinGecko');
    }
  }

  Future<List<TickerModel>> fetchTickers(String coinId) async {
    final url = CoinGeckoConstants.tickersUrl(coinId);
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tickers = data['tickers'] ?? [];
      return tickers.map((e) => TickerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tickers');
    }
  }

  Future<List<ExchangeModel>> fetchExchanges({
    int page = 1,
    int perPage = 100,
  }) async {
    final url = CoinGeckoConstants.exchangesUrl(page: page, perPage: perPage);
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ExchangeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exchanges');
    }
  }

  Future<ExchangeModel> fetchExchangeDetail(String id) async {
    final url = CoinGeckoConstants.exchangeDetailUrl(id);
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ExchangeModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch exchange detail');
    }
  }

  Future<List<TrendingCoin>> fetchTrendingCoins() async {
    final url = CoinGeckoConstants.trendingUrl();
    final response = await _safeGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coins = data['coins'] as List<dynamic>;
      return coins.map((e) => TrendingCoin.fromJson(e['item'])).toList();
    } else {
      throw Exception('Failed to load trending coins');
    }
  }
}
