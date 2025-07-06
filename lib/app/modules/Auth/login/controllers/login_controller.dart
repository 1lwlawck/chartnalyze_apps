import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/utils/validator.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final AuthService authService = Get.find<AuthService>();

  @override
  void onInit() {
    final arg = Get.arguments;
    if (arg is Map && arg['email'] != null) {
      emailController.text = arg['email'];
    }
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final emailInput = emailController.text.trim();
    final passwordInput = passwordController.text.trim();

    final emailError = Validator.validateEmail(emailInput);
    final passwordError = Validator.validatePassword(passwordInput);

    if (emailError != null) {
      _showSnackbar("Error", emailError, isError: true);
      return;
    }

    if (passwordError != null) {
      _showSnackbar("Error", passwordError, isError: true);
      return;
    }

    isLoading.value = true;

    final success = await authService.login(
      email: emailInput,
      password: passwordInput,
    );

    isLoading.value = false;

    if (success) {
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } else {
      _showSnackbar("Error", "Invalid email or password", isError: true);
    }
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : null,
      colorText: isError ? Colors.white : null,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
