import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/utils/validator.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final authService = Get.find<AuthService>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validate fields
    final validationMessage = _validateForm(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (validationMessage != null) {
      _showErrorSnackbar(validationMessage);
      return;
    }

    isLoading.value = true;
    print("📨 Registering: $username / $email");

    try {
      final success = await authService.register(
        username: username,
        email: email,
        password: password,
      );

      if (!success) {
        _showErrorSnackbar('Registration failed.');
        return;
      }

      final loggedIn = await authService.login(
        email: email,
        password: password,
      );
      if (!loggedIn) {
        _showErrorSnackbar('Automatic login failed.');
        return;
      }

      final otpSent = await authService.sendOTP(email);
      if (!otpSent) {
        _showErrorSnackbar('Failed to send OTP.');
        return;
      }

      Get.toNamed(Routes.EMAIL_VERIFICATION, arguments: {'email': email});
    } catch (e) {
      print("❌ Registration error: $e");
      _showErrorSnackbar('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  String? _validateForm({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return Validator.validateUsername(username) ??
        Validator.validateEmail(email) ??
        Validator.validatePassword(password) ??
        Validator.validateConfirmPassword(password, confirmPassword);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
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
