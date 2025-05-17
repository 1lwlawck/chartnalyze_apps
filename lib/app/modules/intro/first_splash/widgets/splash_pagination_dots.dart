import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class SplashPaginationDots extends StatelessWidget {
  const SplashPaginationDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == 0;
        return Container(
          width: 20,
          height: 5,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryGreen : AppColors.inactiveDot,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
