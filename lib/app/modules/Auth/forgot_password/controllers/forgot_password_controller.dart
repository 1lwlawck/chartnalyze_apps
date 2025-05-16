import 'package:chartnalyze_apps/app/constants/strings.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final _authService = AuthService();

  void sendCode() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        AppStrings.errorTitle,
        AppStrings.emptyEmailMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await _authService.sendPasswordResetEmail(email);

    if (success) {
      Get.toNamed(Routes.OTP_RESET_PASSWORD, arguments: email);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
