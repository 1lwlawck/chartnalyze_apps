import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SplashRedirectView extends StatelessWidget {
  const SplashRedirectView({super.key});

  void _initRedirect() {
    // Panggil setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.MAIN_WRAPPER); // Tanpa lazyPut!
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _initRedirect();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(SplashImages.firstSplash, width: 300, height: 300),
            const SizedBox(height: 40),
            const Text(
              'Smart insights, better decisions',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }
}
