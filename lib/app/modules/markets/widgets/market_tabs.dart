import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/markets_controller.dart';

class MarketTabs extends StatelessWidget {
  const MarketTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketsController>(
      builder: (controller) {
        return SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.tabLabels.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final isSelected = controller.selectedTabIndex == index;
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
                              isSelected ? AppColors.primaryGreen : Colors.grey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 20,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
