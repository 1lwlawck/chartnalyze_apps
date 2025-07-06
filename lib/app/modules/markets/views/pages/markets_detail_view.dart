import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/helpers/text_helper.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/market/market_ticker_section.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/chart_interval.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/charts.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/info/coin_info.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/performance_tabs.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/price_header.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/statistic_card.dart';
import 'package:chartnalyze_apps/app/modules/news/views/widgets/news_card.dart';
import 'package:chartnalyze_apps/widgets/shimmer/ShimmerContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MarketDetailView extends GetView<MarketsController> {
  const MarketDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String? coinId;

    if (args != null &&
        args is Map<String, dynamic> &&
        args.containsKey('coinId')) {
      coinId = args['coinId'];
      controller.currentCoinId = coinId;
    } else {
      coinId = controller.currentCoinId;
    }

    if (coinId == null) {
      return const Scaffold(body: Center(child: Text('Coin ID not provided.')));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCoinDetail(coinId!).then((_) {
        final coin = controller.coinDetail.value;
        if (coin != null) {
          controller.fetchNewsForCoin(coin.symbol.toUpperCase());
          controller.fetchMarketTickers(coin.id);
        }
      });
      controller.loadOhlcData(coinId);
    });

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 110,
                  automaticallyImplyLeading: false,
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/bg-appbar.png',
                          ), // Gambar header
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Obx(() {
                    final coin = controller.coinDetail.value;
                    if (coin == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
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
                          IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed:
                                () async => await controller.shareScreenshot(
                                  controller.shareKey,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                          Obx(
                            () => IconButton(
                              icon: SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    controller.isTogglingWatchlist.value
                                        ? const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        )
                                        : Icon(
                                          controller.isCurrentCoinWatched.value
                                              ? Icons.star
                                              : Icons.star_border,
                                          color:
                                              controller
                                                      .isCurrentCoinWatched
                                                      .value
                                                  ? Colors.amber
                                                  : Colors.white,
                                        ),
                              ),
                              onPressed: () async {
                                controller.isTogglingWatchlist.value = true;
                                await controller.toggleWatchlist(
                                  controller.coinDetail.value!,
                                );
                                controller.isTogglingWatchlist.value = false;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  bottom: const TabBar(
                    isScrollable: false,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    indicatorColor: Colors.white,
                    indicatorWeight: 1.6,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: AppFonts.nextTrial,
                    ),
                    tabs: [
                      Tab(text: 'Summary'),
                      Tab(text: 'Info'),
                      Tab(text: 'Market'),
                      Tab(text: 'News'),
                    ],
                  ),
                ),
              ],

          body: RefreshIndicator(
            onRefresh: () async => await controller.fetchCoinDetail(coinId!),
            child: TabBarView(
              children: [
                Obx(() {
                  final coin = controller.coinDetail.value;
                  final loading = controller.isLoadingDetail.value;
                  if (loading || coin == null) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
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
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RepaintBoundary(
                          key: controller.shareKey,
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder:
                                (context) => TextButton(
                                  onPressed: () {
                                    final tabController =
                                        DefaultTabController.of(context);
                                    tabController.animateTo(
                                      1,
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: const Text(
                                    'See All',
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      fontFamily: AppFonts.circularStd,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        MarketStatisticCard(coin: coin),
                      ],
                    ),
                  );
                }),
                Obx(() {
                  final coin = controller.coinDetail.value;
                  final loading = controller.isLoadingDetail.value;
                  if (loading || coin == null) {
                    return const Center(
                      child: SpinKitWave(
                        color: AppColors.primaryGreen,
                        size: 24.0,
                      ),
                    );
                  }
                  return CoinInfoSection(coin: coin);
                }),
                Obx(() {
                  if (controller.isLoadingTickers.value) {
                    return const Center(
                      child: SpinKitWave(
                        color: AppColors.primaryGreen,
                        size: 24.0,
                      ),
                    );
                  }
                  if (controller.tickers.isEmpty) {
                    return const Center(
                      child: Text('No market data available.'),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.only(top: 0),
                    children: [
                      MarketTickerSection(tickers: controller.tickers),
                    ],
                  );
                }),
                Obx(() {
                  if (controller.isLoadingNews.value) {
                    return const Center(
                      child: SpinKitWave(
                        color: AppColors.primaryGreen,
                        size: 24,
                      ),
                    );
                  }
                  if (controller.newsList.isEmpty) {
                    return const Center(
                      child: Text('No news available for this coin.'),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    itemCount: controller.newsList.length,
                    itemBuilder: (context, index) {
                      final news = controller.newsList[index];
                      return NewsCard(news: news);
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
