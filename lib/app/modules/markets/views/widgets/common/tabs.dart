import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/markets_controller.dart';

class MarketTabs extends StatelessWidget {
  const MarketTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketsController>();
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.tabLabels.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTabIndex.value == index;
            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.tabLabels[index],
                      style: TextStyle(
                        color:
                            isSelected
                                ? AppColors.white
                                : AppColors.white.withOpacity(0.6),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 20,
                      color: isSelected ? AppColors.white : Colors.transparent,
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
