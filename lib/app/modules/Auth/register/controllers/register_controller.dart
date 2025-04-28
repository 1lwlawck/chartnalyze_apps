import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // TextEditingController for each field
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetFields() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onInit() {
    super.onInit();
    resetFields();
  }

  // Handle password visibility toggle
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Handle registration logic
  void register() {
    if (validateForm()) {
      Get.toNamed(Routes.EMAIL_VERIFICATION);
    } else {
      // Handle validation error
      Get.snackbar('Error', 'Please fill in all fields correctly');
    }
  }

  // Form validation
  bool validateForm() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      return false; // Passwords must match
    }
    return true;
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
