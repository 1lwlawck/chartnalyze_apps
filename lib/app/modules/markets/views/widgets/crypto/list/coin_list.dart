import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/widgets/shimmer/shimmer_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../coin_list_tile.dart';

class MarketCoinList extends StatefulWidget {
  const MarketCoinList({super.key});

  @override
  State<MarketCoinList> createState() => _MarketCoinListState();
}

class _MarketCoinListState extends State<MarketCoinList> {
  final controller = Get.find<MarketsController>();
  final scrollController = ScrollController();
  bool _hasShownNoDataSheet = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final crypto = controller.crypto;
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !crypto.isFetchingMore.value &&
          crypto.hasMoreData.value) {
        crypto.fetchCoinListData();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crypto = controller.crypto;

    return Obx(() {
      if (crypto.isLoading.value) {
        return ListView.builder(
          itemCount: 8,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          itemBuilder: (_, i) => const ShimmerListTile(type: 'market'),
        );
      }

      if (crypto.coins.isEmpty && !_hasShownNoDataSheet) {
        _hasShownNoDataSheet = true;

        Future.delayed(Duration.zero, () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder:
                (context) => SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(NoData.noData, width: 150, height: 150),
                        const SizedBox(height: 16),
                        Text(
                          'Data not available',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.nextTrial,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Unable to load data from server. Please try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppFonts.nextTrial,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              crypto.fetchCoinListData(isInitial: true);
                              _hasShownNoDataSheet = false;
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text(' Try Again'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontFamily: AppFonts.nextTrial,
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        });
      }

      return RefreshIndicator(
        color: AppColors.primaryGreen,
        backgroundColor: Colors.white,
        displacement: 5,
        onRefresh: () => crypto.fetchCoinListData(isInitial: true),
        child: ListView.builder(
          controller: scrollController,
          itemCount: crypto.coins.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          itemBuilder: (_, i) {
            if (i < crypto.coins.length) {
              final coin = crypto.coins[i];
              return CoinListTile(
                coin: coin,
                index: i,
                onTap:
                    () => Get.toNamed(
                      Routes.MARKETS_DETAIL,
                      arguments: {'coinId': coin.id, 'rate': coin.price},
                    ),
                sparkline: coin.sparkline,
              );
            } else {
              return Obx(() {
                if (crypto.isFetchingMore.value && !crypto.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SpinKitWave(
                        color: AppColors.primaryGreen,
                        size: 30.0,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              });
            }
          },
        ),
      );
    });
  }
}
