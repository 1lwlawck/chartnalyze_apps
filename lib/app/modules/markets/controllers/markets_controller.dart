import 'package:chartnalyze_apps/app/modules/markets/controllers/exchanges_controller.dart';
import 'package:get/get.dart';
import 'crypto_controller.dart';
import 'stock_controller.dart';
import 'watchlist_controller.dart';
import 'overview_controller.dart';
import 'news_coin_controller.dart';
import 'chart_controller.dart';
import 'gainer_loser_controller.dart';

class MarketsController extends GetxController {
  // Sub-controller modular
  final crypto = Get.put(CryptoController());
  final stocks = Get.put(StockController());
  final watchlist = Get.put(WatchlistController());
  final overview = Get.put(MarketOverviewController());
  final news = Get.put(CoinNewsController());
  final chart = Get.put(ChartController());
  final gainers = Get.put(GainerLoserController());
  final exchanges = Get.put(ExchangeController());

  final selectedTabIndex = 0.obs;

  final List<String> tabLabels = [
    'Coins',
    'Stocks',
    'Watchlists',
    'Overview',
    'Exchanges',
  ];

  @override
  void onInit() {
    super.onInit();

    // Panggil semua data awal dari masing-masing controller
    overview.fetchUsdToIdrRate();
    overview.fetchGlobalMarket();
    crypto.fetchCoinListData(isInitial: true);
    stocks.fetchStocksData();
    watchlist.fetchWatchlist();
    chart.fetchAvailableSymbols();
    chart.loadNormalizedData();
    gainers.fetchAndCompute();
    exchanges.fetchExchanges();

    // Restore simbol tersimpan dari chart
    final savedSymbols = Get.find<ChartController>().box.read<List>(
      'selected_symbols',
    );
    if (savedSymbols != null && savedSymbols.isNotEmpty) {
      chart.setSelectedSymbols(List<String>.from(savedSymbols));
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
