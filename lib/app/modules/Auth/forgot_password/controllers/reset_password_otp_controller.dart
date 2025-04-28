import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class ResetPasswordOtpController extends GetxController {
  /// Email yang akan ditampilkan (dinamis)
  final email = 'denyfaishalardiuan@gmail.com'.obs;

  final fields = List.generate(5, (_) => TextEditingController());

  final focusNodes = List.generate(5, (_) => FocusNode());

  var otp = RxList<String>.filled(5, '');

  /// Timer resend
  var counter = 45.obs;
  var isResendEnabled = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    for (var i = 0; i < 6; i++) {
      fields[i].addListener(() => _onFieldChanged(i));
    }
  }

  void _onFieldChanged(int index) {
    final text = fields[index].text;
    if (text.length > 1) {
      fields[index].text = text.substring(text.length - 1);
    }
    otp[index] = fields[index].text;
    if (fields[index].text.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (fields[index].text.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void _startTimer() {
    counter.value = 45;
    isResendEnabled.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isResendEnabled.value = true;
        t.cancel();
      }
    });
  }

  void resendCode() {
    if (!isResendEnabled.value) return;
    // panggil API resend
    _startTimer();
  }

  void submit() {
    final code = otp.join();
    if (code.length == 6) {
      // panggil API untuk verifikasi OTP
      Get.offNamed(Routes.SUCCESS_VERIFICATION);
    } else {
      Get.snackbar('Error', 'Invalid OTP code');
    }

    @override
    void onClose() {
      _timer?.cancel();
      for (var c in fields) c.dispose();
      for (var f in focusNodes) f.dispose();
      super.onClose();
    }
  }
}
