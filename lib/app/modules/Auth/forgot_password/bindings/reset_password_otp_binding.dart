import 'package:get/get.dart';
import '../controllers/reset_password_otp_controller.dart';

class ResetPasswordOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPasswordOtpController());
  }
}
