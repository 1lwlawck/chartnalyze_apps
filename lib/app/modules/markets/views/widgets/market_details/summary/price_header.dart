import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarketPriceHeader extends StatelessWidget {
  final CoinDetailModel coin;
  final double usdToIdrRate;

  const MarketPriceHeader({
    super.key,
    required this.coin,
    required this.usdToIdrRate,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = coin.change24h >= 0;
    final priceIdr = coin.price * usdToIdrRate;

    final idrFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    final usdFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT SIDE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    coin.name.length > 20
                        ? '${coin.name.substring(0, 20)}…'
                        : coin.name,
                    overflow: TextOverflow.ellipsis, // ⬅️ Tambahkan ini
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: AppFonts.nextTrial,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#${coin.rank}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.circularStd,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                usdFormat.format(coin.price),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.nextTrial,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isUp
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    size: 16,
                    color: isUp ? AppColors.primaryGreen : Colors.red,
                  ),

                  const SizedBox(width: 4),
                  Text(
                    idrFormat.format(priceIdr),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFonts.nextTrial,
                      color: isUp ? AppColors.primaryGreen : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 16,
                    color: isUp ? AppColors.primaryGreen : Colors.red,
                  ),
                  Text(
                    '${coin.change24h.toStringAsFixed(2)}% (24h)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUp ? AppColors.primaryGreen : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.circularStd,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // RIGHT SIDE
        Row(
          children: [
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isUp ? AppColors.primaryGreen : Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  Text(
                    '${coin.change24h.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: AppFonts.circularStd,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
