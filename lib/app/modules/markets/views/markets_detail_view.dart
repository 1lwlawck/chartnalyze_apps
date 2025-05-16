import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/market_details/market_chart_interval.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/market_details/market_charts.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/market_details/market_performance_tabs.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/market_details/market_price_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/widgets/market_details/market_statistic_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MarketDetailView extends GetView<MarketsController> {
  const MarketDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String coinId = args['coinId'];

    if (controller.coinDetail.value == null ||
        controller.coinDetail.value?.id != coinId) {
      controller.fetchCoinDetail(coinId);
    }
    if (controller.ohlcData.isEmpty) {
      controller.loadOhlcData(coinId);
    }

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: AppColors.primaryGreen,
                  elevation: 0.5,
                  pinned: true,
                  toolbarHeight: 56, // default, bisa diperkecil jika mau
                  titleSpacing: 0,
                  automaticallyImplyLeading: false,
                  title: Obx(() {
                    final coin = controller.coinDetail.value;
                    if (coin == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const SizedBox(width: 6),
                          ClipOval(
                            child: Image.network(
                              coin.imageUrl,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    coin.symbol.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: AppFonts.nextTrial,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[700],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '#${coin.rank}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                coin.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.star_border,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    );
                  }),

                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(
                      36,
                    ), // default biasanya 48
                    child: TabBar(
                      isScrollable: false,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[300],
                      indicatorColor: Colors.white,
                      indicatorWeight: 1.5,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: AppFonts.nextTrial,
                      ),
                      tabs: const [
                        Tab(text: 'Ringkasan'),
                        Tab(text: 'Info'),
                        Tab(text: 'Pasar'),
                      ],
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            children: [
              /// TAB: Ringkasan
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final coin = controller.coinDetail.value;
                      if (coin == null) {
                        return const SizedBox.shrink(); // atau shimmer/loading
                      }
                      return MarketPriceHeader(
                        coin: coin,
                        usdToIdrRate: controller.usdToIdrRate.value,
                      );
                    }),

                    const SizedBox(height: 12),
                    const MarketChartInterval(),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (controller.isLoadingOhlc.value) {
                        return const Center(
                          child: SpinKitWave(
                            color: AppColors.primaryGreen,
                            size: 30,
                          ),
                        );
                      }
                      return MarketChart(
                        ohlcData: controller.ohlcData,
                        interval: controller.selectedInterval.value,
                      );
                    }),
                    const SizedBox(height: 12),
                    MarketPerformanceTabs(
                      data: {
                        '24H': controller.coinDetail.value!.change24h,
                        '7D': controller.coinDetail.value!.change7d,
                        '1M': controller.coinDetail.value!.change30d,
                      },
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (controller.isLoadingDetail.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final coin = controller.coinDetail.value;
                      if (coin == null) return const SizedBox.shrink();

                      return MarketStatisticCard(coin: coin);
                    }),
                  ],
                ),
              ),

              /// TAB: Info
              const Center(child: Text('Info')),

              /// TAB: Pasar
              const Center(child: Text('Pasar')),

              /// TAB: Portofolio
              const Center(child: Text('Portofolio')),
            ],
          ),
        ),
      ),
    );
  }
}
