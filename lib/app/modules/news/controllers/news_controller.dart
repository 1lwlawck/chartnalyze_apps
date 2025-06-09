import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoindeskService.dart';

class NewsController extends GetxController {
  final _newsService = CoinDeskService();

  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final hasMore = true.obs;
  final newsList = <NewsItem>[].obs;
  final selectedCategoryIndex = 0.obs;
  final selectedCategory = ''.obs;
  final currentPage = 1.obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchNews();
  }

  void _scrollListener() {
    if (!hasMore.value || isLoading.value || isFetchingMore.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchNews(
        categories:
            selectedCategory.value.isNotEmpty ? [selectedCategory.value] : null,
      );
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void selectCategory(int index, String category) {
    selectedCategoryIndex.value = index;
    selectedCategory.value = category;
    currentPage.value = 1;
    hasMore.value = true;
    newsList.clear();
    fetchNewsByCategory(category);
  }

  Future<void> fetchNewsByCategory(String category) async {
    await fetchNews(
      categories: category.isEmpty ? null : [category],
      isRefresh: true,
    );
  }

  Future<void> fetchNews({
    List<String>? categories,
    bool isRefresh = false,
  }) async {
    if (isLoading.value || isFetchingMore.value || !hasMore.value) return;

    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage.value = 1;
        hasMore.value = true;
        newsList.clear();
      } else {
        isFetchingMore.value = true;
      }

      final fetchedNews = await _newsService.fetchNews(
        limit: 10,
        categories: categories,
      );

      if (fetchedNews.isEmpty || fetchedNews.length < 10) {
        hasMore.value = false;
      }

      newsList.addAll(fetchedNews);
      currentPage.value++;
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
