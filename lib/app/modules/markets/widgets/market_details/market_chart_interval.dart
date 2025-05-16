import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';

class MarketChartInterval extends StatelessWidget {
  const MarketChartInterval({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketsController>();

    final List<String> intervals = ['1 day', '1 week', '1 month'];
    final Map<String, String> labels = {
      '1 day': '1D',
      '1 week': '7D',
      '1 month': '1M',
    };

    return Obx(() {
      final selected = controller.selectedInterval.value;

      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // <<-- INI membuat container tidak melebar
            children:
                intervals.map((interval) {
                  final isSelected = selected == interval;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        controller.selectedInterval.value = interval;
                        final id = controller.coinDetail.value?.id ?? '';
                        if (id.isNotEmpty) {
                          controller.loadOhlcData(id);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          labels[interval]!,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? AppColors.primaryGreen
                                    : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      );
    });
  }
}
