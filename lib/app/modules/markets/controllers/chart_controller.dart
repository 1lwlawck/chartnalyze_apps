import 'package:chartnalyze_apps/app/data/models/crypto/NormalizedPricePoint.dart'
    show NormalizedPricePoint;
import 'package:chartnalyze_apps/app/data/models/crypto/PricePointModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/PriceHistoryService.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChartController extends GetxController {
  final PriceHistoryService _service = PriceHistoryService();
  final box = GetStorage();

  final availableSymbols = <String>[].obs;
  final priceHistoryData = <PricePoint>[].obs;
  final isLoading = false.obs;
  final selectedSymbol = ''.obs;

  final selectedSymbols = <String>[].obs;
  final normalizedDataMap = <String, List<NormalizedPricePoint>>{}.obs;

  Future<void> fetchAvailableSymbols() async {
    final symbols = await _service.fetchAvailableSymbols();
    availableSymbols.assignAll(symbols);

    if (symbols.isNotEmpty) {
      // Jika tidak ada simbol tersimpan, pakai default
      final saved = box.read<List>('selected_symbols');
      if (saved != null && saved.isNotEmpty) {
        await setSelectedSymbols(List<String>.from(saved));
      } else {
        // Set default dan simpan
        await setSelectedSymbols(['BTC', 'ETH']);
      }
    }
  }

  Future<void> fetchPriceHistory(String symbol) async {
    isLoading.value = true;
    try {
      final data = await _service.fetchPriceHistory(symbol);
      priceHistoryData.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setSelectedSymbols(List<String> symbols) async {
    selectedSymbols.assignAll(symbols);
    await box.write('selected_symbols', symbols);
    normalizedDataMap.clear();

    final entries = await Future.wait(
      symbols.map((symbol) async {
        try {
          final cached = box.read<List>('price_cache_$symbol');
          final points =
              cached
                  ?.map(
                    (e) => PricePoint.fromJson(Map<String, dynamic>.from(e)),
                  )
                  .toList() ??
              await _service.fetchPriceHistory(symbol);
          box.write(
            'price_cache_$symbol',
            points.map((e) => e.toJson()).toList(),
          );
          return MapEntry(symbol, _normalize(points));
        } catch (_) {
          return MapEntry(symbol, <NormalizedPricePoint>[]);
        }
      }),
    );

    normalizedDataMap.addEntries(entries);
  }

  List<NormalizedPricePoint> _normalize(List<PricePoint> raw) {
    if (raw.isEmpty) return [];
    final sorted = [...raw]..sort((a, b) => a.scrapedAt.compareTo(b.scrapedAt));
    final base = sorted.first.price;
    return sorted.map((e) {
      return NormalizedPricePoint(
        symbol: e.symbol,
        scrapedAt: e.scrapedAt,
        normalizedPrice: (e.price / base) * 100,
      );
    }).toList();
  }

  Future<void> loadNormalizedData() async {
    isLoading.value = true;
    try {
      final Map<String, List<NormalizedPricePoint>> result = {};

      for (final symbol in selectedSymbols) {
        try {
          final cached = box.read<List>('price_cache_$symbol');
          final points =
              cached
                  ?.map(
                    (e) => PricePoint.fromJson(Map<String, dynamic>.from(e)),
                  )
                  .toList() ??
              await _service.fetchPriceHistory(symbol);

          // Cache ulang
          box.write(
            'price_cache_$symbol',
            points.map((e) => e.toJson()).toList(),
          );

          result[symbol] = _normalize(points);
        } catch (e) {
          result[symbol] = [];
          print('Error loading symbol $symbol: $e');
        }
      }

      normalizedDataMap.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshMarketData() async {
    await fetchAvailableSymbols(); // optional
    if (selectedSymbols.isNotEmpty) {
      await loadNormalizedData(); // wajib
    }
  }
}
