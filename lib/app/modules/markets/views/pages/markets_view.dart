import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/stocks/stocks_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/table_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/watched_assets/watched_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/markets_controller.dart';
import '../widgets/crypto/list/coin_list.dart';
import '../widgets/common/filter_bar.dart';
import '../widgets/common/header.dart';
import '../widgets/statistics/stats.dart';
import '../widgets/common/tabs.dart';

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
                      return const MarketStocksList();
                    case 2:
                      return const MarketWatchlistList();
                    case 3:
                      return const Center(child: Text('Overview'));
                    case 4:
                      return const Center(child: Text('Exchanges'));
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
