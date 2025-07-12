import 'package:chartnalyze_apps/app/data/models/stocks/AlphaVantageOHLCModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/AlphaVantageQuoteModel.dart';
import 'package:chartnalyze_apps/app/helpers/dio_client.dart';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:dio/dio.dart';

class AlphaVantageService {
  final Dio _dio = DioClient.dio;

  // Fetch global quote (summary info)
  Future<AlphaVantageQuoteModel> fetchGlobalQuote(String symbol) async {
    final url = AlphaVantageConstants.globalQuoteUrl(symbol: symbol);
    final res = await _dio.getUri(url);
    return AlphaVantageQuoteModel.fromJson(res.data);
  }

  Future<List<AlphaVantageOHLC>> fetchOhlcDaily(String symbol) async {
    final url = AlphaVantageConstants.dailyOhlcUrl(symbol: symbol);
    final res = await _dio.getUri(url);
    final data = res.data as Map<String, dynamic>;
    final timeSeries = data['Time Series (Daily)'] as Map<String, dynamic>;

    return timeSeries.entries
        .map((e) => AlphaVantageOHLC.fromJson(e.key, e.value))
        .toList();
  }

  // Fetch 7-day closes for sparkline chart
  Future<List<double>> fetchSparklineFromAlpha(String symbol) async {
    final url = Uri.parse(
      'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$symbol&outputsize=compact&apikey=${AlphaVantageConstants.apiKey}',
    );

    final res = await _dio.getUri(url);
    final data = res.data['Time Series (Daily)'] as Map<String, dynamic>;

    final closes =
        data.entries
            .take(7)
            .map((e) => double.tryParse(e.value['4. close'] ?? '0') ?? 0)
            .toList()
            .reversed
            .toList();

    return closes;
  }
}
