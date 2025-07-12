import 'package:chartnalyze_apps/app/data/models/crypto/GlobalMarketModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MarketOverviewController extends GetxController {
  final CoinService _coinService = CoinService();

  final usdToIdrRate = 16500.0.obs;
  final marketData = Rxn<GlobalMarketModel>();
  final isLoading = false.obs;

  Future<void> fetchUsdToIdrRate() async {
    try {
      usdToIdrRate.value = await _coinService.fetchUsdToIdrRate();
    } catch (_) {}
  }

  Future<void> fetchGlobalMarket() async {
    isLoading.value = true;
    try {
      marketData.value = await _coinService.fetchGlobalMarketModel(
        previousMarketCap: marketData.value?.totalMarketCap,
        previousVolume: marketData.value?.totalVolume,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
