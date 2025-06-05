import 'package:chartnalyze_apps/app/modules/search/widgets/coin_higlight_card.dart';
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
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg-appbar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search Assets',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Search assets ex: Bitcoin, Ethereum',
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
            ],
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

          if (query.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 🔥 Trending Coins (aman dari error toDouble)
                Obx(() {
                  final coins = controller.trendingCoins;
                  if (coins.isEmpty) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trending Coins',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...coins.map((coin) {
                        final symbol = coin['symbol']?.toUpperCase() ?? '-';
                        final name = coin['name'] ?? '-';
                        final imageUrl = coin['large'] ?? coin['thumb'] ?? '';
                        final changeRaw =
                            coin['data']?['price_change_percentage_24h'];
                        final double change =
                            (changeRaw is num) ? changeRaw.toDouble() : 0.0;

                        return CoinHighlightCard(
                          symbol: symbol,
                          name: name,
                          imageUrl: imageUrl,
                          change: change,
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  );
                }),

                // // 🧩 Trending NFTs (aman dari null dan error parsing)
                // Obx(() {
                //   final nfts = controller.trendingNFTs;
                //   if (nfts.isEmpty) return const SizedBox();

                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'Trending NFTs',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //         ),
                //       ),
                //       const SizedBox(height: 12),
                //       ...nfts.map((nft) {
                //         final name = nft['name'] ?? '-';
                //         final symbol = nft['symbol'] ?? '-';
                //         final thumb = nft['thumb'] ?? '';
                //         final rawChange =
                //             nft['floor_price_in_usd_24h_percentage_change'];
                //         final double change =
                //             (rawChange is num) ? rawChange.toDouble() : 0.0;

                //         return ListTile(
                //           leading: Image.network(
                //             thumb,
                //             width: 30,
                //             height: 30,
                //             errorBuilder:
                //                 (_, __, ___) =>
                //                     const Icon(Icons.image_not_supported),
                //           ),
                //           title: Text(
                //             name,
                //             style: const TextStyle(fontSize: 13),
                //           ),
                //           subtitle: Text(symbol),
                //           trailing: Text(
                //             '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                //             style: TextStyle(
                //               color: change >= 0 ? Colors.green : Colors.red,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //       const SizedBox(height: 24),
                //     ],
                //   );
                // }),

                // // 🏷 Trending Categories
                // Obx(() {
                //   final categories = controller.trendingCategories;
                //   if (categories.isEmpty) return const SizedBox();

                //   return Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Text(
                //         'Trending Categories',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 14,
                //         ),
                //       ),
                //       const SizedBox(height: 12),
                //       ...categories.map((cat) {
                //         final name = cat['name'] ?? '-';
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 4),
                //           child: Text(
                //             '• $name',
                //             style: const TextStyle(fontSize: 13),
                //           ),
                //         );
                //       }).toList(),
                //       const SizedBox(height: 24),
                //     ],
                //   );
                // }),

                // 📌 Recent Assets
                const Text(
                  'Recent Assets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.nextTrial,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (recentAssets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'No recent assets.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
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

          // 🔍 Search Results
          if (results.isEmpty) {
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
