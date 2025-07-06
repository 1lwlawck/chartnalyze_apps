import 'dart:io';
import 'dart:ui' as ui;
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/ExchangeModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/GlobalMarketModel.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/OHLCDataModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubQuoteModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/WatchlistService.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoindeskService.dart';
import 'package:chartnalyze_apps/app/data/services/stocks/FinnhubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MarketsController extends GetxController {
  final CoinService _coinService = CoinService();
  final CoinDeskService _newsService = CoinDeskService();
  final WatchlistService _watchlistService = Get.put(WatchlistService());
  final FinnhubService _stockService = Get.put(FinnhubService());

  var isLoading = true.obs;
  var coins = <CoinListModel>[].obs;
  var detailedWatchlist = <CoinListModel>[].obs;

  var page = 1;
  final perPage = 25;

  var isFetchingMore = false.obs;
  var hasMoreData = true.obs;

  int selectedTabIndex = 0;

  var coinDetail = Rxn<CoinDetailModel>();
  var isLoadingDetail = false.obs;

  final tickers = <TickerModel>[].obs;
  final isLoadingTickers = false.obs;
  final GlobalKey shareKey = GlobalKey();

  var ohlcData = <OHLCDataModel>[].obs;
  var isLoadingOhlc = false.obs;

  final RxBool isChartLoading = false.obs;
  final RxDouble usdToIdrRate = 16500.0.obs;

  final RxString selectedInterval = '1 day'.obs;

  final Rxn<GlobalMarketModel> marketData = Rxn<GlobalMarketModel>();
  final RxBool isGlobalMarketLoading = false.obs;

  final RxList<NewsItem> newsList = <NewsItem>[].obs;
  final RxBool isLoadingNews = false.obs;

  final RxList<CoinListModel> watchlist = <CoinListModel>[].obs;
  final RxBool isLoadingWatchlist = false.obs;
  final RxBool isTogglingWatchlist = false.obs;
  final RxBool isCurrentCoinWatched = false.obs;
  String? currentCoinId;

  final exchanges = <ExchangeModel>[].obs;
  final isLoadingExchanges = false.obs;

  final stocksList = <FinnhubQuoteModel>[].obs;
  final isLoadingStocks = false.obs;

  final List<String> tabLabels = [
    'Coins',
    'Stocks',
    'Watchlists',
    'Overview',
    'Exchanges',
  ];

  final Map<String, int> intervalDaysMap = {
    '1 day': 1,
    '1 week': 7,
    '1 month': 30,
  };

  @override
  void onInit() {
    super.onInit();
    fetchUsdToIdrRate();
    fetchGlobalMarketModel();
    fetchCoinListData(isInitial: true);
    fetchWatchlist();

    fetchExchanges();
    fetchStocksData();

    debounce<String>(selectedInterval, (val) async {
      isChartLoading.value = true;
      final id = coinDetail.value?.id;
      if (id != null) await loadOhlcData(id);
      isChartLoading.value = false;
    }, time: const Duration(milliseconds: 300));
  }

  void changeTab(int index) {
    selectedTabIndex = index;
    update();
  }

  Future<void> fetchStocksData() async {
    isLoadingStocks.value = true;

    final symbols = [
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

    try {
      final fetchedStocks = await Future.wait(
        symbols.map((symbol) async {
          try {
            final quote = await _stockService.fetchQuote(symbol);
            final profile = await _stockService.fetchProfile(symbol);
            final sparkline = await _stockService.fetchAlphaVantageSparkline(
              symbol,
            );
            return quote.copyWith(
              symbol: symbol,
              name: profile.name,
              logo: profile.logo,
              sparkline: sparkline,
            );
          } catch (e) {
            print('Failed fetch $symbol: $e');
            return null;
          }
        }),
      );

      stocksList.assignAll(fetchedStocks.whereType<FinnhubQuoteModel>());
    } finally {
      isLoadingStocks.value = false;
    }
  }

  Future<void> fetchExchanges({int page = 1, int perPage = 100}) async {
    isLoadingExchanges.value = true;
    try {
      final data = await _coinService.fetchExchanges(
        page: page,
        perPage: perPage,
      );
      exchanges.assignAll(data);
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch exchanges', isError: true);
    } finally {
      isLoadingExchanges.value = false;
    }
  }

  Future<void> shareScreenshot(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_chart.png').create();
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Shared Chart');
    } catch (e) {
      _showSnackbar('Error', 'Failed to share screenshot', isError: true);
    }
  }

  Future<void> toggleWatchlist(CoinDetailModel coin) async {
    final coinModel = CoinListModel(
      id: coin.id,
      name: coin.name,
      symbol: coin.symbol,
      icon: coin.imageUrl,
      price: coin.price,
      rank: coin.rank,
      change24h: coin.change24h,
      change7d: coin.change7d,
      marketCap: coin.marketCap,
      sparkline: [],
    );

    final wasWatched = isWatched(coin.id);
    isCurrentCoinWatched.value = !wasWatched;

    if (wasWatched) {
      final success = await _watchlistService.removeFromWatchlist(coin.id);
      if (success) {
        watchlist.removeWhere((item) => item.id == coin.id);
        detailedWatchlist.removeWhere((item) => item.id == coin.id);
      } else {
        isCurrentCoinWatched.value = true;
      }
    } else {
      final success = await _watchlistService.addToWatchlist(coinModel);
      if (success) {
        watchlist.add(coinModel);
        detailedWatchlist.add(coinModel);
      } else {
        isCurrentCoinWatched.value = false;
      }
    }
  }

  bool isWatched(String id) => watchlist.any((item) => item.id == id);

  Future<void> fetchWatchlist() async {
    isLoadingWatchlist.value = true;
    try {
      final rawWatchlist = await _watchlistService.getWatchlist();
      final ids = rawWatchlist.map((e) => e.key).join(',');
      if (ids.isEmpty) {
        watchlist.clear();
        detailedWatchlist.clear();
        return;
      }
      final detailed = await _watchlistService.fetchCoinListDataByIds(ids: ids);
      for (var item in detailed) {
        final match = rawWatchlist.firstWhereOrNull((e) => e.key == item.id);
        if (match != null && match.imageUrl.isNotEmpty) {
          item.icon = match.imageUrl;
        }
      }
      watchlist.assignAll(detailed);
      detailedWatchlist.assignAll(detailed);
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch watchlist', isError: true);
    } finally {
      isLoadingWatchlist.value = false;
    }
  }

  Future<void> fetchUsdToIdrRate() async {
    try {
      final rate = await _coinService.fetchUsdToIdrRate();
      usdToIdrRate.value = rate;
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch currency rate', isError: true);
    }
  }

  Future<void> fetchCoinListData({bool isInitial = false}) async {
    if (isInitial) {
      isLoading.value = true;
      coins.clear();
      page = 1;
      hasMoreData.value = true;
    }

    if (!hasMoreData.value || isFetchingMore.value) return;

    try {
      isFetchingMore.value = true;
      final result = await _coinService.fetchCoinListData(
        vsCurrency: 'usd',
        page: page,
        perPage: perPage,
      );
      if (result.isEmpty) {
        hasMoreData.value = false;
      } else {
        coins.addAll(result);
        coins.sort((a, b) => a.rank.compareTo(b.rank));
        page++;
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch coin data', isError: true);
    } finally {
      isFetchingMore.value = false;
      isLoading.value = false;
    }
  }

  Future<void> fetchCoinDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      ohlcData.clear();
      final result = await _coinService.fetchCoinDetail(id);
      coinDetail.value = result;
      isCurrentCoinWatched.value = isWatched(result.id);
      await loadOhlcData(result.id);
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch coin detail', isError: true);
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> fetchMarketTickers(String coinId) async {
    try {
      isLoadingTickers.value = true;
      final data = await _coinService.fetchTickers(coinId);
      tickers.assignAll(data);
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch market data', isError: true);
    } finally {
      isLoadingTickers.value = false;
    }
  }

  Future<void> loadOhlcData(String coinId) async {
    isLoadingOhlc.value = true;
    try {
      final days = intervalDaysMap[selectedInterval.value] ?? 1;
      final result = await _coinService.fetchOhlcData(
        coinId: coinId,
        vsCurrency: 'usd',
        days: days,
      );
      ohlcData.value = result;
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch OHLC data', isError: true);
      ohlcData.clear();
    } finally {
      isLoadingOhlc.value = false;
    }
  }

  Future<void> fetchGlobalMarketModel() async {
    try {
      isGlobalMarketLoading.value = true;
      final previousData = marketData.value;
      final result = await _coinService.fetchGlobalMarketModel(
        previousMarketCap: previousData?.totalMarketCap,
        previousVolume: previousData?.totalVolume,
      );
      marketData.value = result;
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch market data', isError: true);
    } finally {
      isGlobalMarketLoading.value = false;
    }
  }

  Future<void> fetchNewsForCoin(String symbol) async {
    isLoadingNews.value = true;
    try {
      final news = await _newsService.fetchNews(
        categories: [symbol.toUpperCase()],
        limit: 10,
      );
      newsList.assignAll(news);
    } catch (e) {
      _showSnackbar('Error', 'Failed to fetch news', isError: true);
      newsList.clear();
    } finally {
      isLoadingNews.value = false;
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFE57373) : null,
      colorText: isError ? const Color(0xFFFFFFFF) : null,
    );
  }
}
