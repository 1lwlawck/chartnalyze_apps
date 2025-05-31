import 'dart:ui';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';

class EmailVerificationController extends GetxController {
  EmailVerificationController({required this.email});

  final String email;

  var otpCode = ''.obs;
  var isResendEnabled = false.obs;
  var counter = 60.obs;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    counter.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isResendEnabled.value = true;
        _timer.cancel();
      }
    });
  }

  void resendOTP() async {
    isResendEnabled.value = false;
    startTimer();

    final success = await Get.find<AuthService>().resendOTP(email);
    if (success) {
      Get.snackbar(
        'Success',
        'OTP code has been resent successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Failed',
        'Failed to resend OTP code.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  void submitOTP() async {
    final code = otpCode.value;

    if (code.length != 6) {
      Get.snackbar(
        'Error',
        'OTP code must be 6 digits.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
      return;
    }

    final success = await Get.find<AuthService>().verifyOTP(email, code);

    if (success) {
      Get.offNamed(Routes.SUCCESS_VERIFICATION, arguments: {'email': email});
    } else {
      Get.snackbar(
        'Verification Failed',
        'OTP verification failed. Please make sure the code is correct.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
