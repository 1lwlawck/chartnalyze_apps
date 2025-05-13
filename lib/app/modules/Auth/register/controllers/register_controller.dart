import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/utils/validator.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthService authService = Get.find<AuthService>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    final usernameError = Validator.validateUsername(username);
    final emailError = Validator.validateEmail(email);
    final passwordError = Validator.validatePassword(password);
    final confirmPasswordError = Validator.validateConfirmPassword(
      password,
      confirmPassword,
    );

    if (usernameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      Get.snackbar(
        'Error',
        usernameError ?? emailError ?? passwordError ?? confirmPasswordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final success = await authService.register(
        username: username,
        email: email,
        password: password,
      );

      if (success) {
        Get.toNamed(
          Routes.EMAIL_VERIFICATION,
          arguments: {'email': emailController.text.trim()},
        );
      } else {
        Get.snackbar(
          'Error',
          'Registration failed, username already taken.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
