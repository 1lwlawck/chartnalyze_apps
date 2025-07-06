import 'dart:async';
import 'package:chartnalyze_apps/app/data/models/crypto/SearchCoinModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TrendingCoin.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:flutter/material.dart';

class SearchAssetsController extends GetxController {
  final CoinService _coinService = CoinService();

  final isLoading = false.obs;
  final searchResults = <SearchCoinModel>[].obs;
  final recentAssets = <SearchCoinModel>[].obs;
  final recentSearches = <String>[].obs;
  final trendingCoins = <TrendingCoin>[].obs;

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

  Future<void> loadTrendingCoins() async {
    try {
      isLoading(true);
      final coins = await _coinService.fetchTrendingCoins();
      trendingCoins.assignAll(coins);
    } catch (e) {
      print("[SearchController] Trending coins error: $e");
      _showSnackbar('Error', 'Failed to fetch trending coins', isError: true);
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
      print("[SearchController] Search error: $e");
      _showSnackbar('Error', 'Failed to search coins', isError: true);
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

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFE57373) : null,
      colorText: isError ? const Color(0xFFFFFFFF) : null,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
