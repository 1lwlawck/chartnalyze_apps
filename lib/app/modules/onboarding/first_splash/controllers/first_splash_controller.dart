import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class FirstSplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 3), nextPage);
  }

  void nextPage() {
    Get.offAllNamed(Routes.SECOND_SPLASH);
  }
}
