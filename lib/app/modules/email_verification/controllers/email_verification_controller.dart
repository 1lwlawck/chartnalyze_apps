import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'dart:async';

class EmailVerificationController extends GetxController {
  var otpCode = ''.obs; // To store the OTP code entered by the user
  var email =
      'denyfaishalardiuan@gmail.com'.obs; // Dynamically changeable email
  var isResendEnabled = false.obs; // To enable/disable resend OTP button
  var counter = 60.obs; // Countdown timer
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  // Function to start the countdown timer
  void startTimer() {
    counter.value = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        counter.value--;
      } else {
        isResendEnabled.value = true;
        _timer.cancel();
      }
    });
  }

  // Function to resend OTP and reset timer
  void resendOTP() {
    startTimer();
    isResendEnabled.value = false;
  }

  void submitOTP() {
    Get.offNamed(Routes.SUCCESS_VERIFICATION);
    print("OTP submitted: ${otpCode.value}");
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
