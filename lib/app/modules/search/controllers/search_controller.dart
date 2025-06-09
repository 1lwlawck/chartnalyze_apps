import 'dart:async';
import 'package:chartnalyze_apps/app/data/models/crypto/SearchCoinModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TrendingCoin.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:flutter/material.dart';

class SearchControllers extends GetxController {
  final CoinService _coinService = CoinService();

  var isLoading = false.obs;
  var searchResults = <SearchCoinModel>[].obs;
  var recentAssets = <SearchCoinModel>[].obs;
  var recentSearches = <String>[].obs;
  var trendingCoins = <TrendingCoin>[].obs;
  var trendingNFTs = <Map<String, dynamic>>[].obs;
  var trendingCategories = <Map<String, dynamic>>[].obs;

  final searchController = TextEditingController();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    loadTrendingCoins();
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.isEmpty) {
        searchResults.clear();
      } else {
        searchCoins(query);
      }
    });
  }

  // Future<void> fetchTrendingSearch() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://api.coingecko.com/api/v3/search/trending'),
  //       headers: {'accept': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       trendingCoins.value = List<Map<String, dynamic>>.from(
  //         (data['coins'] as List).map((e) => e['item']),
  //       );

  //       trendingNFTs.value = List<Map<String, dynamic>>.from(data['nfts']);
  //       trendingCategories.value = List<Map<String, dynamic>>.from(
  //         data['categories'],
  //       );
  //     }
  //   } catch (e) {
  //     print('Error fetching trending search: $e');
  //   }
  // }

  Future<void> loadTrendingCoins() async {
    try {
      isLoading(true);
      final coins = await _coinService.fetchTrendingCoins();
      trendingCoins.assignAll(coins);
    } catch (e) {
      trendingCoins.clear();
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchCoins(String query) async {
    try {
      isLoading(true);
      final results = await _coinService.searchCoins(query);
      searchResults.assignAll(results);
    } catch (e) {
      searchResults.clear();
    } finally {
      isLoading(false);
    }
  }

  void addToRecentAsset(SearchCoinModel asset) {
    recentAssets.removeWhere((c) => c.id == asset.id);
    recentAssets.insert(0, asset);
    if (recentAssets.length > 10) {
      recentAssets.removeLast();
    }
  }

  void addToRecentSearch(String query) {
    final clean = query.trim();
    if (clean.isNotEmpty && !recentSearches.contains(clean)) {
      recentSearches.insert(0, clean);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
