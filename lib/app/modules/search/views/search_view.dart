import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/search/controllers/search_controller.dart';
import 'package:chartnalyze_apps/app/modules/search/widgets/search_result_tile.dart';

class SearchView extends GetView<SearchControllers> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cari Aset',
                    style: TextStyle(
                      color: AppColors.white,
                      fontFamily: AppFonts.nextTrial,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari koin atau penukaran...',
                      hintStyle: const TextStyle(
                        fontFamily: AppFonts.circularStd,
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final query = controller.searchController.text;
        final assetsToShow = controller.filteredAssets;
        final recentAssets = controller.recentAssets;

        // Jika tidak mengetik & ada riwayat aset
        if (query.isEmpty && recentAssets.isNotEmpty) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Aset yang Baru Dicari',
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
                      // Get.toNamed(Routes.COIN_DETAIL, arguments: coin);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        // Jika hasil pencarian kosong
        if (query.isNotEmpty && assetsToShow.isEmpty) {
          return const Center(
            child: Text(
              'Data tidak ditemukan.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: assetsToShow.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final coin = assetsToShow[index];
            return SearchResultTile(
              coin: coin,
              onTap: () {
                controller.addToRecentAsset(coin);
                // Get.toNamed(...);
              },
            );
          },
        );
      }),
    );
  }
}
