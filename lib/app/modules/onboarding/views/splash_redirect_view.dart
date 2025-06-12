import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashRedirectView extends StatelessWidget {
  const SplashRedirectView({super.key});

  void _initRedirect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        final token = GetStorage().read('token');
        if (token != null && token.isNotEmpty) {
          Get.offAllNamed(Routes.MAIN_WRAPPER);
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
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
            const SizedBox(height: 40),
            const SpinKitWave(color: AppColors.primaryGreen, size: 30),
          ],
        ),
      ),
    );
  }
}
