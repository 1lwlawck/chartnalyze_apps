import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import 'package:intl/intl.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News'),
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
            fontSize: 30,
            fontFamily: AppFonts.nextTrial,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bottom: const TabBar(
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            indicatorColor: AppColors.primaryGreen,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Direkomendasikan'),
              Tab(text: 'Semua Berita'),
              Tab(text: 'Video'),
            ],
          ),
        ),
        body: Container(
          color: const Color(
              0xFFF9F9F9), // ← Ganti sesuai warna background yang kamu mau
          child: TabBarView(
            children: [
              _buildNewsTab(),
              _buildNewsTab(),
              const Center(child: Text('Video Coming Soon')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsTab() {
    return Obx(() {
      final controller = Get.find<NewsController>();

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchNews(); // ← ambil data terbaru
              },
              child: ListView.builder(
                itemCount: controller.newsList.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (context, index) {
                  final news = controller.newsList[index];
                  return _buildNewsCard(news);
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCategoryChips() {
    final categories = [
      'Semua',
      'Memes',
      'Real World Assets',
      'Solana Ecosystem',
    ];

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              categories[index],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.nextTrial,
                color: AppColors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(dynamic news) {
    final String formattedDate = (() {
      try {
        final date = DateTime.parse(news['published_at']).toLocal();
        return DateFormat('dd MMM yyyy, HH:mm').format(date);
      } catch (_) {
        return '';
      }
    })();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          (news['thumbnail'] != null)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    news['thumbnail'],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, color: Colors.white),
                ),
          const SizedBox(width: 10),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['title'] ?? 'No Title',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: AppFonts.nextTrial,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: AppFonts.nextTrial,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
