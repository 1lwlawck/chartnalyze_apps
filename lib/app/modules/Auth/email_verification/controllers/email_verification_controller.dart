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

  void resendOTP() {
    startTimer();
    isResendEnabled.value = false;
  }

  void submitOTP() {
    print("OTP submitted: ${otpCode.value}");
    Get.offNamed(
      Routes.SUCCESS_VERIFICATION,
      arguments: {'email': email},
    );
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
