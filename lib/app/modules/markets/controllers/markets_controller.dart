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
  final RxBool hasFetchedNews = false.obs;

  final RxList<CoinListModel> watchlist = <CoinListModel>[].obs;
  final RxBool isLoadingWatchlist = false.obs;
  final RxBool isCurrentCoinWatched = false.obs;
  final RxBool isTogglingWatchlist = false.obs;

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
      'AAPL', // Apple
      'GOOGL', // Alphabet (Google)
      'AMZN', // Amazon
      'MSFT', // Microsoft
      'TSLA', // Tesla
      'META', // Meta Platforms (Facebook)
      'NFLX', // Netflix
      'NVDA', // NVIDIA
      'BRK.B', // Berkshire Hathaway
      'V', // Visa
      'JPM', // JPMorgan Chase
      'WMT', // Walmart
      'DIS', // The Walt Disney Company
      'PYPL', // PayPal
      'INTC', // Intel Corporation
      'ADBE', // Adobe Systems
      'CSCO', // Cisco Systems
      'CMCSA', // Comcast Corporation
      'MSTR', // Mastercard
      'VZ', // Verizon Communications
      'ORCL', // Oracle Corporation
      'PFE', // Pfizer Inc.
      'KO', // The Coca-Cola Company
      'PEP', // PepsiCo, Inc.
      'NKE', // Nike, Inc.
      'XOM', // Exxon Mobil Corporation
      'CVX', // Chevron Corporation
      'MRK', // Merck & Co., Inc.
      'ABT', // Abbott Laboratories
      'T', // AT&T Inc.
      'UNH', // UnitedHealth Group
      'HD', // The Home Depot
      'PG', // Procter & Gamble Co.
      'LLY', // Eli Lilly and Company
      'BA', // The Boeing Company
      'WFC', // Wells Fargo & Company
      'BAC', // The Bank of America Corporation
    ];
    final List<FinnhubQuoteModel> results = [];
    try {
      for (var symbol in symbols) {

        try {
          // Fetch quote and profile
          final quote = await _stockService.fetchQuote(symbol);
          final profile = await _stockService.fetchProfile(symbol);

          // Fetch sparkline from Alpha Vantage
          final sparkline = await _stockService.fetchAlphaVantageSparkline(
            symbol,
          );

          // Combine all data
          final enriched = quote.copyWith(
            symbol: symbol,
            name: profile.name,
            logo: profile.logo,
            sparkline: sparkline,
          );

          results.add(enriched);
        } catch (e) {
        }
      }
      stocksList.assignAll(results);
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

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Chart of ${coinDetail.value?.name} Current Price \$${coinDetail.value?.price} Track your ${coinDetail.value?.symbol} Here: ${coinDetail.value?.explorer})',
      );
    } catch (e) {
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

    // Optimistically update state
    final wasWatched = isWatched(coin.id);
    isCurrentCoinWatched.value = !wasWatched;

    if (wasWatched) {
      final success = await _watchlistService.removeFromWatchlist(coin.id);
      if (success) {
        watchlist.removeWhere((item) => item.id == coin.id);
        detailedWatchlist.removeWhere((item) => item.id == coin.id);
      } else {
        isCurrentCoinWatched.value = true; // Revert if failed
      }
    } else {
      final success = await _watchlistService.addToWatchlist(coinModel);
      if (success) {
        watchlist.add(coinModel);
        detailedWatchlist.add(coinModel);
      } else {
        isCurrentCoinWatched.value = false; // Revert if failed
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
    } finally {
      isLoadingWatchlist.value = false;
    }
  }

  Future<void> fetchUsdToIdrRate() async {
    try {
      final rate = await _coinService.fetchUsdToIdrRate();
      usdToIdrRate.value = rate;
    } catch (e) {
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
      Get.snackbar('Error', 'Gagal mengambil data market: $e');
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
    } finally {
      isGlobalMarketLoading.value = false;
    }
  }

  Future<void> fetchNewsForCoin(String symbol) async {
    isLoadingNews.value = true;

    // [DEBUG] Tampilkan simbol coin

    try {
      final news = await _newsService.fetchNews(
        categories: [symbol.toUpperCase()],
        limit: 10,
      );

      // [DEBUG] Cek apakah responsenya kosong atau ada isinya
      for (var n in news) {
      }

      newsList.assignAll(news);
    } catch (e) {
      // [DEBUG] Jika gagal, tampilkan error-nya
      newsList.clear();
    } finally {
      isLoadingNews.value = false;
    }
  }
}
