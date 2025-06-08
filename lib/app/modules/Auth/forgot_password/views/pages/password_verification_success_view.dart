import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class PasswordVerificationSuccessView extends StatelessWidget {
  const PasswordVerificationSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final email = (Get.arguments?['email'] ?? '') as String;

    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/verified_image.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                const Text(
                  AppStrings.emailVerifiedTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.nextTrial,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your password has been successfully reset. You can now log in with your new password.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppFonts.circularStd,
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offNamed(Routes.LOGIN, arguments: {'email': email});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      AppStrings.continueText,
                      style: TextStyle(
                        fontFamily: AppFonts.nextTrial,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
