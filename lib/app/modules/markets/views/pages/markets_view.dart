import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/stocks/stocks_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/table_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/watched_assets/watched_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/markets_controller.dart';
import '../widgets/crypto/list/coin_list.dart';
import '../widgets/statistics/stats.dart';
import '../widgets/common/tabs.dart';

class MarketsView extends GetView<MarketsController> {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 2,
        title: Text(
          'Markets',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // Stats dan Tabs tetap ada di bawah AppBar
          // Stats dan Tabs tetap ada di bawah AppBar
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: const Column(
              children: [
                MarketStats(),
                SizedBox(height: 2),
                MarketTabs(),
                SizedBox(height: 10),
              ],
            ),
          ),
          // Table header
          const SizedBox(height: 10),
          MarketTableHeader(),
          // Konten utama
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
        ],
      ),
    );
  }
}
