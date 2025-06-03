import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/search/controllers/search_controller.dart';
import 'package:chartnalyze_apps/app/modules/search/widgets/search_result_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchView extends GetView<SearchControllers> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.searchController.text.isNotEmpty) {
          controller.searchController.clear();
          controller.searchResults.clear();
          FocusScope.of(context).unfocus();
          return false; // Cegah keluar dulu
        }
        return true; // Boleh keluar
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Assets',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search assets ex: Bitcoin, Ethereum',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(Icons.search),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: SpinKitWave(color: AppColors.primaryGreen, size: 20),
            );
          }

          final query = controller.searchController.text.trim();
          final results = controller.searchResults;
          final recentAssets = controller.recentAssets;

          if (query.isEmpty && recentAssets.isNotEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Recent Assets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.nextTrial,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentAssets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final coin = recentAssets[index];
                    return SearchResultTile(
                      coin: coin,
                      onTap: () {
                        controller.addToRecentAsset(coin);

                        Get.toNamed(
                          Routes.MARKETS_DETAIL,
                          arguments: {'coinId': coin.id},
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }

          if (query.isNotEmpty && results.isEmpty) {
            return const Center(
              child: Text(
                'No results found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final coin = results[index];
              return SearchResultTile(
                coin: coin,
                onTap: () {
                  controller.addToRecentAsset(coin);
                  Get.toNamed(
                    Routes.MARKETS_DETAIL,
                    arguments: {'coinId': coin.id},
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
