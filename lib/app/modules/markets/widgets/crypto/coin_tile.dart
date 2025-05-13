import 'package:chartnalyze_apps/app/helpers/number_format_helper.dart';
import 'package:chartnalyze_apps/app/data/models/CoinModel.dart';
import 'package:chartnalyze_apps/widget/sparkline/sparkline_chart.dart';
import 'package:flutter/material.dart';

import 'change_indicator.dart';

class CoinTile extends StatelessWidget {
  final CoinModel coin;
  final int index;
  final VoidCallback onTap;

  const CoinTile({
    Key? key,
    required this.coin,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sparkData = coin.sparkline;
    final ch24 = coin.change24h;
    final ch7d = coin.change7d;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            // Index
            SizedBox(
              width: 24,
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),

            // Icon + Symbol + Market Cap
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(coin.icon),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.symbol,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          NumberFormatHelper.compact(coin.marketCap),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
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
                NumberFormatHelper.usdt(coin.price),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // 24h Change
            Expanded(flex: 3, child: ChangeIndicator(value: ch24)),

            // 7d Change + Sparkline
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ChangeIndicator(value: ch7d),
                  const SizedBox(height: 2),
                  if (sparkData.isNotEmpty)
                    SparklineWidget(
                      data: sparkData,
                      positive: ch7d >= 0,
                      height: 18,
                      width: 60,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
