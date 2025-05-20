import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../controllers/first_splash_controller.dart';
import '../widgets/splash_pagination_dots.dart';
import '../widgets/splash_text_section.dart';

class FirstSplashView extends GetView<FirstSplashController> {
  const FirstSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SizedBox(height: 60),
          const SplashPaginationDots(),
          const SizedBox(height: 100),
          Center(
            child: Image.asset(
              SplashImages.firstSplash,
              width: 400,
              height: 400,
            ),
          ),
          const SizedBox(height: 70),
          const SplashTextSection(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: controller.nextPage,
              child: const Text(
                'Next Page',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  decoration: TextDecoration.underline,
                  fontFamily: AppFonts.nextTrial,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
