import 'package:chartnalyze_apps/app/data/models/crypto/PricePointModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TopGaninersLosers.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/PriceHistoryService.dart';
import 'package:get/get.dart';

class GainerLoserController extends GetxController {
  final PriceHistoryService _service = PriceHistoryService();
  final gainerLoserList = <GainerLoserItem>[].obs;
  final isLoading = false.obs;

  Future<void> fetchAndCompute() async {
    isLoading.value = true;
    try {
      final symbols = await _service.fetchAvailableSymbols();
      final List<PricePoint> all = [];

      final batched = await Future.wait(
        symbols.map((symbol) async {
          final data = await _service.fetchPriceHistory(symbol);
          return data.map((e) => e.copyWith(symbol: symbol)).toList();
        }),
      );

      for (final list in batched) {
        all.addAll(list);
      }

      final grouped = <String, List<PricePoint>>{};
      for (final point in all) {
        grouped.putIfAbsent(point.symbol, () => []).add(point);
      }

      final List<GainerLoserItem> result = [];

      for (final entry in grouped.entries) {
        final sorted = [...entry.value]
          ..sort((a, b) => a.scrapedAt.compareTo(b.scrapedAt));
        if (sorted.length >= 2) {
          final pct = ((sorted.last.price / sorted.first.price) - 1) * 100;
          result.add(
            GainerLoserItem(
              symbol: entry.key,
              returnPct: double.parse(pct.toStringAsFixed(2)),
            ),
          );
        }
      }

      result.sort((a, b) => b.returnPct.compareTo(a.returnPct));
      gainerLoserList.assignAll([
        ...result.take(3),
        ...result.reversed.take(3),
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}
