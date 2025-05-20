import 'package:chartnalyze_apps/app/modules/news/views/widgets/news_card.dart';
import 'package:chartnalyze_apps/app/modules/news/views/widgets/news_chips.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../constants/colors.dart';
import '../../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  static const categories = [
    {'label': 'All', 'filter': ''},
    {'label': 'Trending', 'filter': 'trending'},
    {'label': 'Bullish', 'filter': 'bullish'},
    {'label': 'Bearish', 'filter': 'bearish'},
    {'label': 'Important', 'filter': 'important'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsList.isEmpty) {
          return const Center(
            child: SpinKitWave(color: AppColors.primaryGreen, size: 24),
          );
        }

        return Column(
          children: [
            NewsCategoryChips(categories: categories),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchNews(isRefresh: true);
                },
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount:
                      controller.newsList.length + 1, // +1 untuk loader bawah
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) {
                    if (index < controller.newsList.length) {
                      return NewsCard(news: controller.newsList[index]);
                    } else {
                      return Obx(() {
                        if (controller.isFetchingMore.value &&
                            controller.hasMore.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: SpinKitWave(
                                color: AppColors.primaryGreen,
                                size: 24,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
