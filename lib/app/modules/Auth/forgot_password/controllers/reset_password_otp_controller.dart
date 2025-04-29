import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart'; // Pastikan path ini benar

class ResetPasswordOtpController extends GetxController {
  var email = ''.obs;
  var otpCode = ''.obs;
  var isResendEnabled = false.obs;
  var counter = 60.obs;

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

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

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
