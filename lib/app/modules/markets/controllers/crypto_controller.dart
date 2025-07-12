import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/OHLCDataModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoindeskService.dart';

class CryptoController extends GetxController {
  final CoinService _coinService = CoinService();
  final CoinDeskService _newsService = CoinDeskService();

  final isLoading = false.obs;
  final isLoadingDetail = false.obs;
  final isLoadingTickers = false.obs;
  final isLoadingOhlc = false.obs;
  final isLoadingNews = false.obs;

  final coins = <CoinListModel>[].obs;
  final coinDetail = Rxn<CoinDetailModel>();
  final tickers = <TickerModel>[].obs;
  final ohlcData = <OHLCDataModel>[].obs;
  final newsList = <NewsItem>[].obs;

  int page = 1;
  final int perPage = 25;
  final hasMoreData = true.obs;
  final isFetchingMore = false.obs;

  final intervalDaysMap = {'1 day': 1, '1 week': 7, '1 month': 30};

  final selectedInterval = '1 day'.obs;
  final usdToIdrRate = 16500.0.obs;
  String? currentCoinId;
  final GlobalKey shareKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    fetchUsdToIdrRate();
    debounce<String>(selectedInterval, (val) async {
      final id = coinDetail.value?.id;
      if (id != null) await loadOhlcData(id);
    }, time: const Duration(milliseconds: 300));
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
      print('❌ Failed to fetch coin list: $e');
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
    try {
      isLoadingTickers.value = true;
      final data = await _coinService.fetchTickers(coinId);
      tickers.assignAll(data);
    } catch (e) {
      print('❌ Failed to fetch market tickers: $e');
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
      ohlcData.assignAll(result);
    } catch (e) {
      print('❌ Failed to fetch OHLC data: $e');
      ohlcData.clear();
    } finally {
      isLoadingOhlc.value = false;
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
      print('❌ Failed to fetch news: $e');
      newsList.clear();
    } finally {
      isLoadingNews.value = false;
    }
  }
}
