import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/overview/components/bar_chart_builder.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/overview/components/line_chart_builder.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/overview/components/selector_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';

class MarketOverviewChartView extends StatelessWidget {
  const MarketOverviewChartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketsController>();

    return Obx(() {
      final chartController = controller.chart;
      final gainerController = controller.gainers;

      return RefreshIndicator(
        onRefresh: () async {
          await chartController.refreshMarketData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📊 Crypto Dashboard (Last 30 Days)',
                  style: GoogleFonts.inter(
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Track market trends and performance of selected crypto assets over the last month.',
                  style: GoogleFonts.aBeeZee(
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Dropdown selector
                MultiSelectFloatingDropdown(
                  items: chartController.availableSymbols,
                  selectedItems: chartController.selectedSymbols,
                  onChanged: (List<String> selectedItems) async {
                    await chartController.setSelectedSymbols(
                      selectedItems,
                    ); // Trigger update
                  },
                ),

                const SizedBox(height: 28),
                Text(
                  '📈 Asset Performance Comparison',
                  style: GoogleFonts.aBeeZee(
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                // Grafik
                SizedBox(
                  height: 320,
                  child:
                      chartController.isLoading.value
                          ? const Center(
                            child: SpinKitWave(
                              color: AppColors.primaryGreen,
                              size: 20.0,
                            ),
                          )
                          : chartController.normalizedDataMap.isEmpty
                          ? Center(
                            child: Text(
                              "No data available to display.",
                              style: GoogleFonts.aBeeZee(),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: NormalizedLineChart(
                              dataMap: chartController.normalizedDataMap,
                            ),
                          ),
                ),

                const SizedBox(height: 36),
                Text(
                  '🏆 Top Gainers & Losers',
                  style: GoogleFonts.aBeeZee(
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 300,
                  child:
                      gainerController.gainerLoserList.isEmpty
                          ? const Center(child: Text("No data available."))
                          : TopGainersLosersBarChart(
                            items: gainerController.gainerLoserList,
                          ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
