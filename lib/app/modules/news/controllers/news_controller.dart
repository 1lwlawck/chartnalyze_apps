import 'package:chartnalyze_apps/app/services/news/NewsMetaService.dart';
import 'package:chartnalyze_apps/app/services/news/CoinPanicService.dart';
import 'package:get/get.dart';

class NewsController extends GetxController {
  final _newsService = CoinPanicService();
  final _metaService = NewsMetaService();

  var isLoading = true.obs;
  var newsList = [].obs;

  // Tambahkan ini untuk chip kategori
  var selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      isLoading(true);
      final fetched = await _newsService.fetchTrendingNews();

      // Tambahkan thumbnail dari metadata
      final enriched = await Future.wait(
        fetched.map((item) async {
          final url = item['url'];
          final thumb = await _metaService.getThumbnail(url);
          return {...item, 'thumbnail': thumb};
        }),
      );

      newsList.assignAll(enriched);
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      isLoading(false);
    }
  }
}
