import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final otpCode = ''.obs;
  final isResendEnabled = false.obs;
  final counter = 60.obs;
  final email = ''.obs;
  final _authService = Get.find<AuthService>();

  Timer? _timer;

  @override
  void onInit() {
    final arg = Get.arguments;
    if (arg is String) {
      email.value = arg;
    } else if (arg is Map<String, String>) {
      email.value = arg['email'] ?? '';
      otpCode.value = arg['code'] ?? '';
    }
    super.onInit();
  }

  void requestOTP() async {
    final emailInput = emailController.text.trim();
    if (emailInput.isEmpty) {
      _showSnackbar('Error', 'Email cannot be empty', isError: true);
      return;
    }

    final success = await _authService.sendPasswordResetOTP(emailInput);
    if (success) {
      email.value = emailInput;
      _startTimer();
      Get.toNamed(Routes.OTP_RESET_PASSWORD, arguments: emailInput);
    } else {
      _showSnackbar('Error', 'Failed to send OTP', isError: true);
    }
  }

  void resendOTP() async {
    if (!isResendEnabled.value) return;

    final result = await _authService.sendPasswordResetOTP(email.value);
    if (result) {
      _startTimer();
      _showSnackbar('Success', 'OTP has been resent to your email');
    } else {
      _showSnackbar('Error', 'Failed to resend OTP', isError: true);
    }
  }

  void verifyOTPAndProceed() {
    if (otpCode.value.length != 6) {
      _showSnackbar('Error', 'Enter 6-digit OTP', isError: true);
      return;
    }

    Get.toNamed(
      Routes.CHANGE_PASSWORD,
      arguments: {'email': email.value, 'code': otpCode.value},
    );
  }

  void updatePassword() async {
    final password = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('Error', 'Password cannot be empty', isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackbar('Error', 'Password too short', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackbar('Error', 'Passwords do not match', isError: true);
      return;
    }

    final success = await _authService.resetPassword(
      email: email.value,
      code: otpCode.value,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (success) {
      _showSnackbar('Success', 'Password updated');

      FocusScope.of(Get.context!).unfocus();
      await Future.delayed(const Duration(milliseconds: 100));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(
          Routes.SUCCESS_CHANGE_PASSWORD,
          arguments: {'email': email.value},
        );
      });
    } else {
      _showSnackbar('Error', 'Failed to update password', isError: true);
    }
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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

  void _startTimer() {
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

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFE57373) : null,
      colorText: isError ? const Color(0xFFFFFFFF) : null,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
