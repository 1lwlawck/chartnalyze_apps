import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/crypto/list/coin_list.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/table_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/common/tabs.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/exchanges/exchanges_list.dart';
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
        preferredSize: const Size.fromHeight(200),
        child: Stack(
          children: [
            // Background image with rounded bottom
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

            // Foreground content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Markets',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
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

      body: Column(
        children: [
          // Body konten berdasarkan tab
          Expanded(
            child: GetBuilder<MarketsController>(
              builder: (controller) {
                switch (controller.selectedTabIndex) {
                  case 0: // Coins
                    return Column(
                      children: const [
                        SizedBox(height: 5),
                        MarketTableHeader(),
                        Expanded(child: MarketCoinList()),
                      ],
                    );
                  case 1: // Stocks
                    return const MarketStocksList();
                  case 2: // Watchlists
                    return Column(
                      children: const [
                        SizedBox(height: 10),
                        MarketTableHeader(),
                        Expanded(child: MarketWatchlistList()),
                      ],
                    );
                  case 3: // Overview
                    return const Center(child: Text('Overview'));
                  case 4: // Exchanges
                    return const ExchangesListView();
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
