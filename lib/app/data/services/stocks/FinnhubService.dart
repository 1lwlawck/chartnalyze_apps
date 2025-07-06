import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubQuoteModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubSymbolModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubProfileModel.dart';
import 'package:chartnalyze_apps/app/data/services/stocks/AlphaVantageService.dart';
import 'package:chartnalyze_apps/app/helpers/dio_client.dart';
import 'package:dio/dio.dart';

class FinnhubService {
  final Dio _dio = DioClient.dio;

  /// Fetch all symbols from Finnhub
  Future<List<FinnhubSymbolModel>> fetchSymbols({
    String exchange = 'US',
  }) async {
    final url = FinnhubConstants.symbolsUrl(exchange: exchange);
    final res = await _dio.getUri(url);

    return (res.data as List)
        .map((e) => FinnhubSymbolModel.fromJson(e))
        .toList();
  }

  /// Fetch quote for single symbol
  Future<FinnhubQuoteModel> fetchQuote(String symbol) async {
    final url = FinnhubConstants.quoteUrl(symbol);
    final res = await _dio.getUri(url);

    if (res.data == null || res.data is! Map<String, dynamic>) {
      throw Exception('Invalid quote response for $symbol: ${res.data}');
    }

    return FinnhubQuoteModel.fromJson(res.data);
  }

  /// Batch fetch quotes (optimized multiple symbols)
  Future<Map<String, FinnhubQuoteModel>> fetchQuotesBatch(
    List<String> symbols,
  ) async {
    final futures = symbols.map((symbol) async {
      try {
        final quote = await fetchQuote(symbol);
        return MapEntry(symbol, quote);
      } catch (e) {
        print('Failed to fetch quote for $symbol: $e');
        return null;
      }
    });

    final results = await Future.wait(futures);
    return Map.fromEntries(
      results.whereType<MapEntry<String, FinnhubQuoteModel>>(),
    );
  }

  /// Fetch profile for single symbol
  Future<FinnhubProfileModel> fetchProfile(String symbol) async {
    final url = FinnhubConstants.profileUrl(symbol);
    final res = await _dio.getUri(url);

    if (res.data == null || res.data is! Map<String, dynamic>) {
      throw Exception('Invalid profile response for $symbol: ${res.data}');
    }

    return FinnhubProfileModel.fromJson(res.data);
  }

  /// Fetch sparkline chart using AlphaVantage fallback
  Future<List<double>> fetchAlphaVantageSparkline(String symbol) {
    final alphaService = AlphaVantageService();
    return alphaService.fetchSparklineFromAlpha(symbol);
  }
}
