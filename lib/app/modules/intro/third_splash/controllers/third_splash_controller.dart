import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class ThirdSplashController extends GetxController {
  void navigateToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void navigateToLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}
