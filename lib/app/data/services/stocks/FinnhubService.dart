import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubQuoteModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubSymbolModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubProfileModel.dart';
import 'package:chartnalyze_apps/app/data/services/stocks/AlphaVantageService.dart';
import 'package:chartnalyze_apps/app/helpers/dio_client.dart';
import 'package:dio/dio.dart';

class FinnhubService {
  final Dio _dio = DioClient.dio;

  Future<List<FinnhubSymbolModel>> fetchSymbols({
    String exchange = 'US',
  }) async {
    final url = FinnhubConstants.symbolsUrl(exchange: exchange);
    final res = await _dio.getUri(url);
    return (res.data as List)
        .map((e) => FinnhubSymbolModel.fromJson(e))
        .toList();
  }

  Future<FinnhubQuoteModel> fetchQuote(String symbol) async {
    final url = FinnhubConstants.quoteUrl(symbol);
    final res = await _dio.getUri(url);

    // Debug Rate Limit
    final headers = res.headers.map;
      '→ X-RateLimit-Remaining: ${headers['x-ratelimit-remaining']?.first}',
    );

    //  Cek isi data sebelum parsing
    if (res.data == null || res.data is! Map<String, dynamic>) {
      throw Exception(' Invalid quote response for $symbol: ${res.data}');
    }

    return FinnhubQuoteModel.fromJson(res.data);
  }

  Future<FinnhubProfileModel> fetchProfile(String symbol) async {
    final url = Uri.parse(
      'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=${FinnhubConstants.apiKey}',
    );
    final res = await _dio.getUri(url);

    if (res.data == null || res.data is! Map<String, dynamic>) {
      throw Exception(' Invalid profile response for $symbol: ${res.data}');
    }

    return FinnhubProfileModel.fromJson(res.data);
  }

  Future<List<double>> fetchAlphaVantageSparkline(String symbol) {
    final alphaService = AlphaVantageService();
    return alphaService.fetchSparklineFromAlpha(symbol);
  }
}
