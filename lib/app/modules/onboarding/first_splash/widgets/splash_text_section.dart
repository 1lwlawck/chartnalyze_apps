import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/fonts.dart';

class SplashTextSection extends StatelessWidget {
  const SplashTextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Smart insights, better decisions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Get real-time analysis and trends\nto stay ahead in the market.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
      ],
    );
  }
}
