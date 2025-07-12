import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubQuoteModel.dart';
import 'package:chartnalyze_apps/app/data/services/stocks/FinnhubService.dart';
import 'package:get/get.dart';

class StockController extends GetxController {
  final FinnhubService _stockService = Get.put(FinnhubService());

  final stocksList = <FinnhubQuoteModel>[].obs;
  final isLoadingStocks = false.obs;

  final List<String> symbols = [
    'AAPL',
    'GOOGL',
    'AMZN',
    'MSFT',
    'TSLA',
    'META',
    'NFLX',
    'NVDA',
    'BRK.B',
    'V',
    'JPM',
    'WMT',
    'DIS',
    'PYPL',
    'INTC',
    'ADBE',
    'CSCO',
    'CMCSA',
    'MSTR',
    'VZ',
    'ORCL',
    'PFE',
    'KO',
    'PEP',
    'NKE',
    'XOM',
    'CVX',
    'MRK',
    'ABT',
    'T',
    'UNH',
    'HD',
    'PG',
    'LLY',
    'BA',
    'WFC',
    'BAC',
  ];

  // In-memory cache
  final Map<String, FinnhubQuoteModel> _quoteCache = {};

  Future<void> fetchStocksData() async {
    isLoadingStocks.value = true;

    try {
      final results = await Future.wait(
        symbols.map((symbol) async {
          if (_quoteCache.containsKey(symbol)) {
            return _quoteCache[symbol];
          }

          try {
            final quote = await _stockService.fetchQuote(symbol);
            final profile = await _stockService.fetchProfile(symbol);
            final sparkline = await _stockService.fetchAlphaVantageSparkline(
              symbol,
            );

            final result = quote.copyWith(
              symbol: symbol,
              name: profile.name,
              logo: profile.logo,
              sparkline: sparkline,
            );

            _quoteCache[symbol] = result;
            return result;
          } catch (e) {
            print('Failed to fetch $symbol: $e');
            return null;
          }
        }),
      );

      stocksList.assignAll(results.whereType<FinnhubQuoteModel>());
    } finally {
      isLoadingStocks.value = false;
    }
  }
}
