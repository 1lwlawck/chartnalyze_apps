import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/news/controllers/news_controller.dart';

class NewsCategoryChips extends StatelessWidget {
  final List<Map<String, String>> categories;

  const NewsCategoryChips({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();

    return Container(
      height: 34,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder:
            (_, index) => Obx(() {
              final isSelected =
                  controller.selectedCategoryIndex.value == index;
              return GestureDetector(
                onTap: () async {
                  controller.selectCategory(
                    index,
                    categories[index]['filter']!,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    categories[index]['label']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.nextTrial,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
