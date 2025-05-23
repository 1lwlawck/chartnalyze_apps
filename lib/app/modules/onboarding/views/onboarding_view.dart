// lib/app/modules/onboarding/views/onboarding_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/images.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          _buildFirstSplash(),
          _buildSecondSplash(),
          _buildThirdSplash(),
        ],
      ),
    );
  }

  Widget _buildFirstSplash() {
    return Column(
      children: [
        const SizedBox(height: 60),
        controller.buildDots(0),
        const SizedBox(height: 100),
        Center(
          child: Image.asset(SplashImages.firstSplash, width: 400, height: 400),
        ),
        const SizedBox(height: 70),
        const Text(
          'Smart insights, better decisions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Get real-time analysis and trends\nto stay ahead in the market.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
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
                fontFamily: AppFonts.nextTrial,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondSplash() {
    return Column(
      children: [
        const SizedBox(height: 60),
        controller.buildDots(1),
        const SizedBox(height: 100),
        Image.asset(SplashImages.secondSplash, width: 400, height: 400),
        const SizedBox(height: 50),
        const Text(
          'Multi-Assets Coverage',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Track stocks, crypto, and global indices in one powerful dashboard.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
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
                fontFamily: AppFonts.nextTrial,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdSplash() {
    return Column(
      children: [
        const SizedBox(height: 60),
        controller.buildDots(0),
        const SizedBox(height: 100),
        Image.asset(SplashImages.thirdSplash, width: 400, height: 400),
        const SizedBox(height: 40),
        const Text(
          'AI-Powered Predictions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Make smarter moves with intelligent forecasts and data-driven suggestions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.nextTrial,
          ),
        ),
        const SizedBox(height: 90),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.navigateToRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: controller.navigateToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
