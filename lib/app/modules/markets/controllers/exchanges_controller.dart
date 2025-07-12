import 'package:chartnalyze_apps/app/data/models/crypto/ExchangeModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:get/get.dart';

class ExchangeController extends GetxController {
  final CoinService _coinService = CoinService();

  final exchanges = <ExchangeModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchExchanges({int page = 1, int perPage = 100}) async {
    isLoading.value = true;
    try {
      final data = await _coinService.fetchExchanges(
        page: page,
        perPage: perPage,
      );
      exchanges.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch exchanges');
    } finally {
      isLoading.value = false;
    }
  }
}
