import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../coin_tile.dart';

class MarketCoinList extends GetView<MarketsController> {
  const MarketCoinList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketsController>(
      builder: (c) {
        if (c.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        if (c.coins.isEmpty)
          return const Center(child: Text('No coin data available'));

        return RefreshIndicator(
          onRefresh: c.fetchCoinData,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            itemCount: c.coins.length,
            itemBuilder:
                (_, i) => CoinTile(
                  coin: c.coins[i],
                  index: i,
                  onTap:
                      () => Get.toNamed(
                        Routes.MARKETS_DETAIL,
                        arguments: c.coins[i],
                      ),
                ),
          ),
        );
      },
    );
  }
}
