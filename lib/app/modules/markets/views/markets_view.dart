import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/stocks/market_stocks_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/common/market_table_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/markets_controller.dart';
import '../widgets/crypto/list/market_coin_list.dart';
import '../widgets/common/market_filter_bar.dart';
import '../widgets/common/market_header.dart';
import '../widgets/statistics/market_stats.dart';
import '../widgets/common/market_tabs.dart';

class MarketsView extends GetView<MarketsController> {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const MarketHeader(),
            const MarketStats(),
            const MarketTabs(),
            const MarketFilterBar(),
            MarketTableHeader(),
            Expanded(
              child: GetBuilder<MarketsController>(
                builder: (controller) {
                  switch (controller.selectedTabIndex) {
                    case 0:
                      return const MarketCoinList();
                    case 1:
                      return const Center(child: Text('Watchlists'));
                    case 2:
                      return const Center(child: Text('Overview'));
                    case 3:
                      return const Center(child: Text('Exchanges'));
                    case 4:
                      return const MarketStocksList(); // Tambahkan ini
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
