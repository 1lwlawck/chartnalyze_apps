import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/data/models/news/NewsItemModel.dart';
import 'package:chartnalyze_apps/app/data/services/news/CoindeskService.dart';

class NewsController extends GetxController {
  final _newsService = CoinDeskService();

  final newsList = <NewsItem>[].obs;
  final isLoading = false.obs;
  final isFetchingMore = false.obs;
  final hasMore = true.obs;

  final selectedCategoryIndex = 0.obs;
  final selectedCategory = ''.obs;

  final searchKeyword = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final currentPage = 1.obs;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchNews();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (!hasMore.value || isLoading.value || isFetchingMore.value) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (searchKeyword.value.isNotEmpty && searchKeyword.value.length >= 3) {
        // Search scroll
        searchNews(searchKeyword.value);
      } else {
        fetchNews(
          categories:
              selectedCategory.value.isNotEmpty
                  ? [selectedCategory.value]
                  : null,
        );
      }
    }
  }

  void selectCategory(int index, String category) {
    selectedCategoryIndex.value = index;
    selectedCategory.value = category;
    searchKeyword.value = '';
    searchController.clear();
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
    if ((isLoading.value && !isRefresh) || isFetchingMore.value) return;

    try {
      if (isRefresh || currentPage.value == 1) {
        isLoading.value = true;
        currentPage.value = 1;
        hasMore.value = true;
        newsList.clear();
      } else {
        isFetchingMore.value = true;
      }

      final fetched = await _newsService.fetchNews(
        limit: 10,
        categories: categories,
      );

      if (fetched.length < 10) hasMore.value = false;

      newsList.addAll(fetched);
      currentPage.value++;
    } catch (e) {
      print('[NewsController] Error fetching news: $e');
      _showSnackbar('Error', 'Failed to load news', isError: true);
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  Future<void> searchNews(String keyword) async {
    if (keyword.trim().length < 3) {
      filterNewsLocally(keyword);
      return;
    }

    try {
      isLoading.value = true;
      searchKeyword.value = keyword;
      currentPage.value = 1;
      hasMore.value = false;

      final result = await _newsService.searchNews(keyword);
      newsList.assignAll(result);
    } catch (e) {
      print('[NewsController] Search error: $e');
      _showSnackbar('Error', 'Search failed', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void filterNewsLocally(String keyword) {
    searchKeyword.value = keyword;

    final lower = keyword.toLowerCase();
    final filtered =
        newsList.where((item) {
          return item.title.toLowerCase().contains(lower) ||
              (item.body?.toLowerCase().contains(lower) ?? false);
        }).toList();

    newsList.assignAll(filtered);
  }

  Future<void> openInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      _showSnackbar('Error', 'Failed to open link', isError: true);
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFE57373) : null,
      colorText: isError ? Colors.white : null,
    );
  }
}
