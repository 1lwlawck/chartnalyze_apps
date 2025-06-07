import 'package:chartnalyze_apps/app/modules/news/views/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/colors.dart';
import '../../controllers/news_controller.dart';

class NewsView extends GetView<NewsController> {
  const NewsView({super.key});

  static const categories = [
    {'label': 'All', 'category': ''},
    {'label': 'Altcoin', 'category': 'ALTCOIN'},
    {'label': 'Bitcoin', 'category': 'BTC'},
    {'label': 'Business', 'category': 'BUSINESS'},
    {'label': 'Trading', 'category': 'TRADING'},
    {'label': 'Market', 'category': 'MARKET'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bg-appbar.png',
              ), // ← pastikan path sesuai
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),

          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Discover",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "News from Crypto World",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search any news here',
                        hintStyle: GoogleFonts.newsreader(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w800,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(categories.length, (index) {
                            final isSelected =
                                controller.selectedCategoryIndex.value == index;

                            return GestureDetector(
                              onTap:
                                  () => controller.selectCategory(
                                    index,
                                    categories[index]['category']!,
                                  ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      categories[index]['label']!,
                                      style: GoogleFonts.newsreader(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      height: 2,
                                      width: 24,
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.newsList.isEmpty) {
          return const Center(
            child: SpinKitWave(color: AppColors.primaryGreen, size: 24),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchNews(isRefresh: true);
          },
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.newsList.length + 1,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        );
      }),
    );
  }
}
