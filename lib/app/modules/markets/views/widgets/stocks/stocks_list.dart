import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/stocks/stock_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketStocksList extends GetView<MarketsController> {
  const MarketStocksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.stocks.isLoadingStocks.value;
      final stockList = controller.stocks.stocksList;

      if (isLoading) {
        return const Center(
          child: SpinKitWave(color: AppColors.primaryGreen, size: 32),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.stocks.fetchStocksData,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: stockList.length + 1, // +1 for header
          separatorBuilder:
              (_, index) =>
                  index == 0
                      ? const SizedBox(height: 12)
                      : const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '#',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Stock',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'Price',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          '24H',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '7D',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final stock = stockList[index - 1];
            return StockListTile(
              stock: stock,
              index: index - 1,
              onTap: () {
                // TODO: Navigasi ke halaman detail saham
              },
            );
          },
        ),
      );
    });
  }
}
