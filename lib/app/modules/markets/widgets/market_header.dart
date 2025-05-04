import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';

class MarketHeader extends StatelessWidget {
  const MarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Markets',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
              fontFamily: AppFonts.nextTrial,
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, color: AppColors.primaryGreen),
          // const SizedBox(width: 16),
          // const CircleAvatar(radius: 16, backgroundColor: Colors.grey),
        ],
      ),
    );
  }
}
