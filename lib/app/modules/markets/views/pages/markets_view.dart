import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/pages/camera_live_predict_view.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/crypto/list/coin_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/table_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/tabs.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/exchanges/exchanges_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/overview/market_overview.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/stocks/stocks_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/statistics/stats.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/watched_assets/watched_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketsView extends GetView<MarketsController> {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: IntrinsicHeight(
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
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Markets',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Text(
                        'Explore the latest market trends and statistics',
                        style: GoogleFonts.newsreader(
                          fontSize: 17,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const MarketStats(),
                      const SizedBox(height: 0),
                      const MarketTabs(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final tabIndex = controller.selectedTabIndex.value;
              switch (tabIndex) {
                case 0:
                  return Column(
                    children: const [
                      SizedBox(height: 5),
                      MarketTableHeader(),
                      Expanded(child: MarketCoinList()),
                    ],
                  );
                case 1:
                  return const MarketStocksList();
                case 2:
                  return Column(
                    children: const [
                      SizedBox(height: 10),
                      MarketTableHeader(),
                      Expanded(child: MarketWatchlistList()),
                    ],
                  );
                case 3:
                  return const MarketOverviewChartView();
                case 4:
                  return const ExchangesListView();
                default:
                  return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),

      floatingActionButton: Obx(() {
        if (controller.selectedTabIndex.value == 0) {
          return FloatingActionButton(
            onPressed: () {
              Get.to(() => LivePredictCameraView());
            },
            backgroundColor: AppColors.primaryGreen,
            tooltip: 'Open Camera',
            elevation: 5,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          );
        }
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
