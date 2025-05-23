import 'package:chartnalyze_apps/app/data/models/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/GlobalMarketModel.dart';
import 'package:chartnalyze_apps/app/data/models/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/models/OHLCDataModel.dart';
import 'package:chartnalyze_apps/app/data/models/TickerModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoinPanicService.dart';
import 'package:get/get.dart';

class MarketsController extends GetxController {
  final CoinService _coinService = CoinService();
  final CoinPanicService _newsService = CoinPanicService();

  var isLoading = true.obs;
  var coins = <CoinListModel>[].obs;

  var page = 1;
  final perPage = 25;

  var isFetchingMore = false.obs;
  var hasMoreData = true.obs;

  int selectedTabIndex = 0;

  var coinDetail = Rxn<CoinDetailModel>();
  var isLoadingDetail = false.obs;

  final tickers = <TickerModel>[].obs;
  final isLoadingTickers = false.obs;

  var ohlcData = <OHLCDataModel>[].obs;
  var isLoadingOhlc = false.obs;

  final RxBool isChartLoading = false.obs;
  final RxDouble usdToIdrRate = 16500.0.obs; // Default, replaced via API

  final RxString selectedInterval = '1 day'.obs;

  final Rxn<GlobalMarketModel> marketData = Rxn<GlobalMarketModel>();
  final RxBool isGlobalMarketLoading = false.obs;

  final RxList<NewsItem> newsList = <NewsItem>[].obs;
  final RxBool isLoadingNews = false.obs;
  final RxBool hasFetchedNews = false.obs;

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

  Future<void> fetchUsdToIdrRate() async {
    try {
      final rate = await _coinService.fetchUsdToIdrRate();
      usdToIdrRate.value = rate;
    } catch (e) {
      print('❌ Failed to fetch USD to IDR rate: $e');
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
      print('❌ Error fetching coins: $e');
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
      await loadOhlcData(result.id);
    } catch (e) {
      print('❌ Failed to fetch coin detail: $e');
    } finally {
      isLoadingDetail.value = false;
    }
  }

  Future<void> fetchMarketTickers(String coinId) async {
    isLoadingTickers.value = true;
    try {
      final result = await _coinService.fetchTickers(coinId);
      tickers.assignAll(result);
    } catch (e) {
      tickers.clear();
      print('❌ Error fetching tickers: $e');
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
      print('❌ Failed to fetch OHLC data: $e');
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
      print('❌ Failed to fetch global market data: $e');
    } finally {
      isGlobalMarketLoading.value = false;
    }
  }

  Future<void> fetchNewsForCoin(String symbol) async {
    isLoadingNews.value = true;
    try {
      final news = await _newsService.fetchNews(currencies: symbol);
      newsList.assignAll(news);
    } catch (e) {
      newsList.clear();
      print('Error fetching news for $symbol: $e');
    } finally {
      isLoadingNews.value = false;
    }
  }
}
