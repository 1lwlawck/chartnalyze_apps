import 'package:chartnalyze_apps/app/modules/news/controllers/news_controller.dart';
import 'package:get/get.dart';
import '../../markets/controllers/markets_controller.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainWrapperController>(() => MainWrapperController());

    Get.put(MarketsController(), permanent: true);
    Get.put(NewsController(), permanent: true);
  }
}
