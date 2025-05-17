import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/helpers/text_helper.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/chart_interval.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/charts.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/performance_tabs.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/price_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/statistic_card.dart';

import 'package:chartnalyze_apps/widgets/shimmer/ShimmerContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketDetailView extends GetView<MarketsController> {
  const MarketDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final String coinId = args['coinId'];

    controller.fetchCoinDetail(coinId);
    controller.loadOhlcData(coinId);

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
                  toolbarHeight: 56,
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
                              errorBuilder:
                                  (_, __, ___) => const Icon(Icons.error),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
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
                                safeTruncate(coin.name, 17),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ...[
                            Icons.search,
                            Icons.share_outlined,
                            Icons.notifications_none,
                            Icons.star_border,
                          ].map(
                            (icon) => IconButton(
                              icon: Icon(icon, color: Colors.white, size: 20),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  bottom: TabBar(
                    isScrollable: false,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    indicatorColor: Colors.white,
                    indicatorWeight: 1.6,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: AppFonts.nextTrial,
                    ),
                    tabs: const [
                      Tab(text: 'Ringkasan'),
                      Tab(text: 'Info'),
                      Tab(text: 'Pasar'),
                      Tab(text: 'Portofolio'),
                      Tab(text: 'Berita'),
                    ],
                  ),
                ),
              ],
          body: RefreshIndicator(
            onRefresh: () async => await controller.fetchCoinDetail(coinId),
            child: TabBarView(
              children: [
                /// Ringkasan
                Obx(() {
                  final coin = controller.coinDetail.value;
                  final loading = controller.isLoadingDetail.value;

                  if (loading || coin == null) {
                    return ListView(
                      padding: const EdgeInsets.all(12),
                      children: const [
                        ShimmerContainer(width: double.infinity, height: 60),
                        SizedBox(height: 12),
                        ShimmerContainer(width: double.infinity, height: 40),
                        SizedBox(height: 12),
                        ShimmerContainer(width: double.infinity, height: 240),
                        SizedBox(height: 12),
                        ShimmerContainer(width: double.infinity, height: 80),
                      ],
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    children: [
                      MarketPriceHeader(
                        coin: coin,
                        usdToIdrRate: controller.usdToIdrRate.value,
                      ),
                      const SizedBox(height: 12),
                      const MarketChartInterval(),
                      const SizedBox(height: 12),
                      Obx(() {
                        if (controller.isLoadingOhlc.value) {
                          return const ShimmerContainer(
                            width: double.infinity,
                            height: 240,
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
                          '24H': coin.change24h,
                          '7D': coin.change7d,
                          '1M': coin.change30d,
                        },
                      ),
                      const SizedBox(height: 12),
                      MarketStatisticCard(coin: coin),
                    ],
                  );
                }),

                /// Info
                const Center(child: Text('Info')),

                /// Pasar
                const Center(child: Text('Pasar')),

                /// Portofolio
                const Center(child: Text('Portofolio')),

                /// Berita
                const Center(child: Text('Berita')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
