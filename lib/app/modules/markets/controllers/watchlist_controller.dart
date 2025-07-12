import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/WatchlistService.dart';
import 'package:get/get.dart';

class WatchlistController extends GetxController {
  final WatchlistService _watchlistService = Get.put(WatchlistService());

  final watchlist = <CoinListModel>[].obs;
  final detailedWatchlist = <CoinListModel>[].obs;
  final isLoading = false.obs;
  final isToggling = false.obs;
  final isCurrentWatched = false.obs;

  Future<void> fetchWatchlist() async {
    isLoading.value = true;
    try {
      final raw = await _watchlistService.getWatchlist();
      final ids = raw.map((e) => e.key).join(',');
      if (ids.isEmpty) {
        watchlist.clear();
        detailedWatchlist.clear();
        return;
      }
      final detailed = await _watchlistService.fetchCoinListDataByIds(ids: ids);
      for (var item in detailed) {
        final match = raw.firstWhereOrNull((e) => e.key == item.id);
        if (match != null && match.imageUrl.isNotEmpty) {
          item.icon = match.imageUrl;
        }
      }
      watchlist.assignAll(detailed);
      detailedWatchlist.assignAll(detailed);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(CoinDetailModel coin) async {
    final coinModel = CoinListModel.fromDetail(coin);
    final wasWatched = watchlist.any((e) => e.id == coin.id);
    isCurrentWatched.value = !wasWatched;

    final success =
        wasWatched
            ? await _watchlistService.removeFromWatchlist(coin.id)
            : await _watchlistService.addToWatchlist(coinModel);

    if (success) {
      await fetchWatchlist();
    } else {
      isCurrentWatched.value = wasWatched;
    }
  }
}
