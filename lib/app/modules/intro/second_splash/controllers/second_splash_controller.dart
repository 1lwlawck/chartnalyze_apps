import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class SecondSplashController extends GetxController {
  void nextPage() {
    Get.offNamed(Routes.THIRD_SPLASH);
  }
}
