import 'package:chartnalyze_apps/app/modules/news/controllers/news_controller.dart';
import 'package:chartnalyze_apps/app/modules/search/controllers/search_controller.dart';
import 'package:get/get.dart';
import '../../markets/controllers/markets_controller.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainWrapperController>(MainWrapperController(), permanent: true);

    Get.put(MarketsController(), permanent: true);
    Get.put(NewsController(), permanent: true);
    Get.put(SearchAssetsController(), permanent: true);
  }
}
