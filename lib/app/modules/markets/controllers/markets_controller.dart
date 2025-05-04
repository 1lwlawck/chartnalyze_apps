import 'package:chartnalyze_apps/app/services/CoinService.dart';
import 'package:get/get.dart';

class MarketsController extends GetxController {
  int selectedTabIndex = 0;
  var isLoading = true.obs;

  final List<String> tabLabels = [
    'Coins',
    'Stocks',
    'Watchlists',
    'Overview',
    'Exchanges'
  ];

  void changeTab(int index) {
    selectedTabIndex = index;
    update();
  }

  final CoinService _coinService = CoinService();
  List<Map<String, dynamic>> coins = [];

  Future<void> fetchCoinData() async {
    try {
      isLoading.value = true;
      final fetched = await _coinService.fetchCoins();
      coins = fetched;
    } catch (e) {
      print('Error fetching coins: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCoinData();
  }
}
