import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoindeskService.dart';
import 'package:get/get.dart';

class CoinNewsController extends GetxController {
  final CoinDeskService _newsService = CoinDeskService();

  final newsList = <NewsItem>[].obs;
  final isLoading = false.obs;

  Future<void> fetchNewsForCoin(String symbol) async {
    isLoading.value = true;
    try {
      final news = await _newsService.fetchNews(
        categories: [symbol.toUpperCase()],
        limit: 10,
      );
      newsList.assignAll(news);
    } finally {
      isLoading.value = false;
    }
  }
}
