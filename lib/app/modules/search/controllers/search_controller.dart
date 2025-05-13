import 'package:chartnalyze_apps/app/data/models/CoinModel.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/services/crypto/CoinService.dart';

import 'package:flutter/material.dart';

class SearchControllers extends GetxController {
  final CoinService _coinService = CoinService();

  var isLoading = true.obs;
  var assets = <CoinModel>[].obs;
  var filteredAssets = <CoinModel>[].obs;
  var recentSearches = <String>[].obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAssets();
    searchController.addListener(() {
      filterAssets(searchController.text);
    });
  }

  void fetchAssets() async {
    try {
      isLoading.value = true;
      final result = await _coinService.fetchCoins();
      print("Fetched: ${result.length} assets");
      assets.assignAll(result);
      filteredAssets.assignAll(result);
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterAssets(String query) {
    if (query.isEmpty) {
      filteredAssets.assignAll(assets);
    } else {
      final lower = query.toLowerCase();
      filteredAssets.assignAll(
        assets.where(
          (item) =>
              item.symbol.toLowerCase().contains(lower) ||
              item.id.toLowerCase().contains(lower),
        ),
      );
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
    super.onClose();
  }
}
