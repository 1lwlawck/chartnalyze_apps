import 'package:chartnalyze_apps/app/modules/search/widgets/coin_higlight_card.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
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
          preferredSize: const Size.fromHeight(160),
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
                      const SizedBox(height: 0),
                      Text(
                        'Find your favorite coins quickly and easily',
                        style: GoogleFonts.newsreader(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),

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
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (query.isEmpty) ...[
                //  Trending Coins
                if (controller.trendingCoins.isNotEmpty) ...[
                  Text(
                    'Trending Coins',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...controller.trendingCoins.map(
                    (coin) => CoinHighlightCard(
                      coinId: coin.id,
                      symbol: coin.symbol.toUpperCase(),
                      name: coin.name,
                      imageUrl: coin.imageUrl,
                      change: coin.priceChange24h,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                Text(
                  'Recent Assets',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (recentAssets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'No recent assets.',
                      style: GoogleFonts.poppins(color: Colors.grey),
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

              //  Search Results
              if (query.isNotEmpty) ...[
                if (results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: Text(
                        'No results found',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                  ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
