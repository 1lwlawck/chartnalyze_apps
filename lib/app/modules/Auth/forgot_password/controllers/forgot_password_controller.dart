// lib/app/modules/auth/forgot_password/controllers/forgot_password_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';

class ForgotPasswordController extends GetxController {
  // STEP 1 - EMAIL
  final emailController = TextEditingController();
  final _authService = AuthService();

  // STEP 2 - OTP
  var email = ''.obs;
  var otpCode = ''.obs;
  var isResendEnabled = false.obs;
  var counter = 60.obs;
  Timer? _timer;
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // STEP 3 - PASSWORD
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // === Step 1: Kirim Email ===
  void sendCode() async {
    final emailInput = emailController.text.trim();
    if (emailInput.isEmpty) {
      Get.snackbar(AppStrings.errorTitle, AppStrings.emptyEmailMessage);
      return;
    }

    final success = await _authService.sendPasswordResetEmail(emailInput);
    if (success) {
      email.value = emailInput;
      Get.toNamed(Routes.OTP_RESET_PASSWORD, arguments: emailInput);
    }
  }

  // === Step 2: OTP ===
  void startTimer() {
    counter.value = 60;
    isResendEnabled.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isResendEnabled.value = true;
        _timer?.cancel();
      }
    });
  }

  void resendOTP() {
    startTimer();
    Get.snackbar('Success', 'OTP has been resent');
  }

  void submitOTP() {
    if (otpCode.value.length != 6) {
      Get.snackbar('Error', 'Please enter all 6 digits');
      return;
    }
    Get.snackbar('Success', 'OTP verified successfully');
    Get.toNamed(Routes.CHANGE_PASSWORD);
  }

  void handleOtpInput(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      Future.delayed(const Duration(milliseconds: 50), () {
        focusNodes[index + 1].requestFocus();
      });
    } else if (value.isEmpty && index > 0) {
      Future.delayed(const Duration(milliseconds: 50), () {
        focusNodes[index - 1].requestFocus();
      });
    }
    otpCode.value = otpControllers.map((c) => c.text).join();
  }

  // === Step 3: Password ===
  void toggleNewPasswordVisibility() => isNewPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

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

    // TODO: Call API update password
    Get.snackbar('Success', 'Password updated successfully');
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onInit() {
    final arg = Get.arguments;
    if (arg is String) {
      email.value = arg;
    }
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.onClose();
  }
}
