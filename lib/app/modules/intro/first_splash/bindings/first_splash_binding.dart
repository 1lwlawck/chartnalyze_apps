import 'package:get/get.dart';

import '../controllers/first_splash_controller.dart';

class FirstSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirstSplashController>(
      () => FirstSplashController(),
    );
  }
}
