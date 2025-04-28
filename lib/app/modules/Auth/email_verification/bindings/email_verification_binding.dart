// lib/modules/email_verification/bindings/email_verification_binding.dart
import 'package:get/get.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationController>(
        () => EmailVerificationController());
  }
}
