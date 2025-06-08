import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/stocks/FinnhubQuoteModel.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/helpers/number_format_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class StockListTile extends StatelessWidget {
  final FinnhubQuoteModel stock;
  final int index;
  final VoidCallback onTap;

  const StockListTile({
    super.key,
    required this.stock,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = stock.currentPrice >= stock.previousClose;
    final percentChange =
        ((stock.currentPrice - stock.previousClose) / stock.previousClose) *
        100;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 9, 10),
        margin: const EdgeInsets.only(bottom: 16),
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
                '${index + 1}',
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
                    child:
                        stock.logo != null && stock.logo!.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: stock.logo!,
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                              placeholder: (_, __) => const SizedBox.shrink(),
                              errorWidget:
                                  (_, __, ___) =>
                                      const Icon(Icons.business, size: 18),
                            )
                            : const Icon(Icons.business, size: 24),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.symbol ?? '-',
                          style: GoogleFonts.poppins(
                            color: AppColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          stock.name ?? 'Unknown',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  NumberFormatHelper.usdt(stock.currentPrice),
                  style: GoogleFonts.poppins(
                    color: AppColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  NumberFormatHelper.percent(percentChange),
                  style: TextStyle(
                    color: isUp ? AppColors.primaryGreen : AppColors.errorRed,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    stock.sparkline.isNotEmpty
                        ? SizedBox(
                          height: 20,
                          width: 60,
                          child: Sparkline(
                            data: stock.sparkline,
                            lineColor:
                                isUp
                                    ? AppColors.primaryGreen
                                    : AppColors.errorRed,
                            fillMode: FillMode.below,
                            fillColor: (isUp
                                    ? AppColors.primaryGreen
                                    : AppColors.errorRed)
                                .withOpacity(0.15),
                            lineWidth: 1.5,
                            useCubicSmoothing: true,
                          ),
                        )
                        : const Text(
                          '–',
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
