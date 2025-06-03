import 'package:chartnalyze_apps/app/modules/news/controllers/news_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsCategoryChips extends GetView<NewsController> {
  final List<Map<String, String>> categories;
  const NewsCategoryChips({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: List.generate(categories.length, (index) {
          final label = categories[index]['label']!;
          final category = categories[index]['category']!;

          // Bungkus hanya bagian yang pakai Rx
          return Obx(() {
            final isSelected = controller.selectedCategoryIndex.value == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) => controller.selectCategory(index, category),
                selectedColor: Colors.green[700],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
