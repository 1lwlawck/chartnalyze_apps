import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/data/models/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoinPanicService.dart';

class NewsController extends GetxController {
  final _newsService = CoinPanicService();

  final isLoading = false.obs;
  final newsList = <NewsItem>[].obs;
  final selectedCategoryIndex = 0.obs;
  final currentPage = 1.obs;
  final hasMore = true.obs;
  final isFetchingMore = false.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchNews();
  }

  void _scrollListener() {
    if (!hasMore.value || isLoading.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchNews();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchNews({String? filter, bool isRefresh = false}) async {
    if (isLoading.value || isFetchingMore.value || !hasMore.value) return;

    try {
      if (isRefresh) {
        isLoading(true);
        currentPage.value = 1;
        hasMore.value = true;
        newsList.clear();
      } else {
        isFetchingMore(true);
      }

      final fetchedNews = await _newsService.fetchNews(
        filter: filter,
        currencies: null,
        page: currentPage.value,
      );

      if (fetchedNews.isEmpty || fetchedNews.length < 20) {
        hasMore.value = false;
      }

      newsList.addAll(fetchedNews);
      currentPage.value++;
    } catch (e) {
      print('❌ Error fetching news: $e');
    } finally {
      isLoading(false);
      isFetchingMore(false);
    }
  }

  void selectCategory(int index, String filter) {
    selectedCategoryIndex.value = index;
    fetchNewsByFilter(filter);
  }

  Future<void> fetchNewsByFilter(String? filter) async {
    await fetchNews(
      filter: filter?.isEmpty == true ? null : filter,
      isRefresh: true,
    );
  }

  Future<void> openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw '❌ Could not launch $url';
    }
  }
}
