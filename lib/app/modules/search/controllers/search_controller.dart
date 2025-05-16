import 'package:chartnalyze_apps/app/data/models/CoinListModel.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';

import 'package:flutter/material.dart';

class SearchControllers extends GetxController {
  final CoinService _coinService = CoinService();

  var isLoading = true.obs;
  var assets = <CoinListModel>[].obs;
  var filteredAssets = <CoinListModel>[].obs;
  var recentAssets = <CoinListModel>[].obs;
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
      final result = await _coinService.fetchCoinListData(); // pakai list model
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
              item.name.toLowerCase().contains(lower),
        ),
      );
    }
  }

  void addToRecentAsset(CoinListModel asset) {
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
    super.onClose();
  }
}
