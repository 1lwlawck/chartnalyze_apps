import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendCode() {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.toNamed(Routes.OTP_RESET_PASSWORD, arguments: emailController.text);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
