import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';

class ChangePasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void updatePassword() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(AppStrings.errorTitle, AppStrings.passwordEmpty);
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(AppStrings.errorTitle, AppStrings.passwordTooShort);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(AppStrings.errorTitle, AppStrings.passwordsNotMatch);
      return;
    }

    // TODO: API update password

    Get.snackbar("Success", "Password updated successfully");
    Get.offNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
