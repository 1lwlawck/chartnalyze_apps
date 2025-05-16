import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';

class MarketPerformanceTabs extends StatelessWidget {
  final Map<String, double> data;

  const MarketPerformanceTabs({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final labels = data.keys.toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(labels.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Container(width: 1, height: 15, color: Colors.grey[300]);
              } else {
                final label = labels[index ~/ 2];
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: AppFonts.circularStd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 3),
          Row(
            children: List.generate(labels.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Container(width: 1, height: 22, color: Colors.grey[300]);
              } else {
                final label = labels[index ~/ 2];
                final value = data[label]!;
                final isUp = value >= 0;

                return Expanded(
                  child: Center(
                    child: Text(
                      '${isUp ? '+' : ''}${value.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.circularStd,
                        color: isUp ? AppColors.primaryGreen : Colors.red,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
