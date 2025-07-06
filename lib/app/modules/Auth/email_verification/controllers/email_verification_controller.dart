import 'dart:async';
import 'dart:ui';

import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  EmailVerificationController({required this.email});

  final String email;

  final otpCode = ''.obs;
  final isResendEnabled = false.obs;
  final counter = 60.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    counter.value = 60;
    _timer?.cancel(); // pastikan tidak double timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isResendEnabled.value = true;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOTP() async {
    isResendEnabled.value = false;
    _startTimer();

    final success = await Get.find<AuthService>().resendOTP(email);
    if (success) {
      _showSnackbar(
        title: 'Success',
        message: 'OTP code has been resent successfully.',
        isError: false,
      );
    } else {
      _showSnackbar(
        title: 'Failed',
        message: 'Failed to resend OTP code.',
        isError: true,
      );
    }
  }

  Future<void> submitOTP() async {
    final code = otpCode.value.trim();

    if (code.length != 6) {
      _showSnackbar(
        title: 'Error',
        message: 'OTP code must be 6 digits.',
        isError: true,
      );
      return;
    }

    final success = await Get.find<AuthService>().verifyOTP(email, code);

    if (success) {
      Get.offNamed(Routes.SUCCESS_VERIFICATION, arguments: {'email': email});
    } else {
      _showSnackbar(
        title: 'Verification Failed',
        message:
            'OTP verification failed. Please make sure the code is correct.',
        isError: true,
      );
    }
  }

  void _showSnackbar({
    required String title,
    required String message,
    bool isError = false,
  }) {
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
    super.onClose();
  }
}
