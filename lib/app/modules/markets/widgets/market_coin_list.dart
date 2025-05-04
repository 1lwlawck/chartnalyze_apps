import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/helpers/number_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import '../controllers/markets_controller.dart';

class MarketCoinList extends GetView<MarketsController> {
  const MarketCoinList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketsController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.coins.isEmpty) {
          return const Center(child: Text('No coin data available'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchCoinData();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            itemCount: controller.coins.length,
            itemBuilder: (_, index) {
              final coin = controller.coins[index];

              final price = double.tryParse(coin['price'].toString()) ?? 0;
              final marketCap =
                  double.tryParse(coin['marketCap'].toString()) ?? 0;
              final change24h = double.tryParse(coin['change'].toString()) ?? 0;
              final change7d =
                  double.tryParse(coin['change7d'].toString()) ?? 0;
              final sparkline = coin['sparkline'] ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Index
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    // Icon + Symbol + Market Cap
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(coin['icon']),
                            radius: 14,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${coin['symbol']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.nextTrial,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  NumberFormatHelper.compact(marketCap),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Expanded(
                      flex: 3,
                      child: Text(
                        NumberFormatHelper.usdt(price),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.nextTrial,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    // 24h Change
                    Expanded(
                      flex: 3,
                      child: _buildChangeWidget(change24h),
                    ),

                    // 7d Change + Sparkline
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildChangeWidget(change7d),
                          const SizedBox(height: 2),
                          if (sparkline.isNotEmpty)
                            SizedBox(
                              height: 18,
                              width: 60,
                              child: Sparkline(
                                data: List<double>.from(sparkline),
                                lineColor:
                                    change7d >= 0 ? Colors.green : Colors.red,
                                lineWidth: 1.5,
                                fillMode: FillMode.none,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildChangeWidget(double value) {
    final isPositive = value >= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: isPositive ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 2),
        Text(
          NumberFormatHelper.percent(value.abs()),
          style: TextStyle(
            color: isPositive ? AppColors.primaryGreen : Colors.red,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.circularStd,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
