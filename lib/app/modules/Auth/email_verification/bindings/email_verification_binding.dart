import 'package:get/get.dart';
import '../controllers/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    final email = Get.arguments['email'] ?? '';
    Get.lazyPut(() => EmailVerificationController(email: email));
  }
}
