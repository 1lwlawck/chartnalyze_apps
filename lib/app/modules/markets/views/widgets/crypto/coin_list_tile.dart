import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/helpers/number_format_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinListTile extends StatelessWidget {
  final CoinListModel coin;
  final int index;
  final VoidCallback onTap;
  final List<double> sparkline;

  const CoinListTile({
    super.key,
    required this.coin,
    required this.index,
    required this.onTap,
    required this.sparkline,
  });

  @override
  Widget build(BuildContext context) {
    final isUp24h = coin.change24h >= 0;
    final isUp7d = coin.change7d >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 9, 10),

        margin: const EdgeInsets.only(top: 0, bottom: 16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                '${coin.rank}',
                style: GoogleFonts.poppins(
                  color: AppColors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: coin.icon,
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const SizedBox.shrink(),
                      errorWidget:
                          (context, url, error) =>
                              const Icon(Icons.error, size: 18),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.symbol,
                          style: GoogleFonts.poppins(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          NumberFormatHelper.compact(coin.marketCap),
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    NumberFormatHelper.usdt(coin.price),
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    NumberFormatHelper.percent(coin.change24h),
                    style: TextStyle(
                      color:
                          isUp24h ? AppColors.primaryGreen : AppColors.errorRed,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberFormatHelper.percent(coin.change7d),
                      style: TextStyle(
                        color:
                            isUp7d
                                ? AppColors.primaryGreen
                                : AppColors.errorRed,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (sparkline.length > 12)
                      SizedBox(
                        height: 18,
                        width: 60,
                        child: Sparkline(
                          data: List.generate(
                            12,
                            (i) =>
                                sparkline[(i * sparkline.length ~/ 12).clamp(
                                  0,
                                  sparkline.length - 1,
                                )],
                          ),
                          lineColor:
                              isUp7d
                                  ? AppColors.primaryGreen
                                  : AppColors.errorRed,
                          fillMode: FillMode.below,
                          fillColor: (isUp7d
                                  ? AppColors.primaryGreen
                                  : AppColors.errorRed)
                              .withOpacity(0.15),
                          lineWidth: 1.5,
                          useCubicSmoothing: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
