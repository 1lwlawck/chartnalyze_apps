import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/crypto/coin_list_tile.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketWatchlistList extends GetView<MarketsController> {
  const MarketWatchlistList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final detailedWatchlist = controller.detailedWatchlist;
      final isLoading = controller.isLoadingWatchlist.value;

      if (isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (detailedWatchlist.isEmpty) {
        return const Center(
          child: Text(
            "Your watchlist is empty.",
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFonts.circularStd,
              color: AppColors.primaryGreen,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await controller.fetchWatchlist();
        },
        child: ListView.builder(
          itemCount: detailedWatchlist.length,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          itemBuilder: (_, index) {
            final coin = detailedWatchlist[index];
            return CoinListTile(
              coin: coin,
              index: index,
              onTap:
                  () => Get.toNamed(
                    Routes.MARKETS_DETAIL,
                    arguments: {'coinId': coin.id, 'rate': coin.price},
                  ),
              sparkline: coin.sparkline,
            );
          },
        ),
      );
    });
  }
}
