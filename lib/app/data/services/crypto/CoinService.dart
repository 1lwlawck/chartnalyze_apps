import 'dart:convert';
import 'package:chartnalyze_apps/app/data/models/crypto/GlobalMarketModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/SearchCoinModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';
import 'package:http/http.dart' as http;
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/OHLCDataModel.dart';

// for testing purposes only
Future<http.Response> safeGet(Uri url, {int retries = 3}) async {
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

class CoinService {
  // Fetch list of coins
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

    final response = await safeGet(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => CoinListModel.fromJson(e)).toList();
    } else {
      throw Exception('Server responded with ${response.statusCode}');
    }
  }

  // fetch coin detail
  Future<CoinDetailModel> fetchCoinDetail(String id) async {
    final url = CoinGeckoConstants.detailUrl(id);
    final response = await safeGet(url);
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return CoinDetailModel.fromJson(jsonMap);
    } else {
      throw Exception('Failed to fetch detail for $id');
    }
  }

  // fetch ohlc
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

    final response = await safeGet(url);
    if (response.statusCode == 200) {
      return List<List<dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load OHLC raw data');
    }
  }

  // fetch volume
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

    final response = await safeGet(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return List<List<dynamic>>.from(body['total_volumes']);
    } else {
      throw Exception('Failed to load volume data');
    }
  }

  // fetch ohlc and volume
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
            (v) => (v[0] - timestamp).abs() < 30 * 60 * 1000, // ±30 menit
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

  // fetch usd to idr
  Future<double> fetchUsdToIdrRate() async {
    final url = CoinGeckoConstants.usdToIdrRateUrl();
    final response = await http.get(url);

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
    final response = await safeGet(url);

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return GlobalMarketModel.fromJson(
        jsonMap,
      ); // nanti previous disisipkan dari controller
    } else {
      throw Exception('Failed to fetch global market data');
    }
  }

  /// CoinGecko Search API
  Future<List<SearchCoinModel>> searchCoins(String query) async {
    final url = CoinGeckoConstants.searchCoinUrl(query);
    final response = await safeGet(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coins = data['coins'];
      return coins.map((e) => SearchCoinModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search coins from CoinGecko');
    }
  }

  Future<List<TickerModel>> fetchTickers(String coinId) async {
    final url = Uri.parse(
      "${CoinGeckoConstants.baseUrl}/coins/$coinId/tickers?include_exchange_logo=true&depth=false&order=trust_score_desc&per_page=10&page=1&sparkline=false",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> tickers = data['tickers'] ?? [];
      return tickers.map((e) => TickerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tickers');
    }
  }
}
