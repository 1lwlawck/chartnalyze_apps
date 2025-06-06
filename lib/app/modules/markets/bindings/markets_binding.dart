import 'package:get/get.dart';
import '../controllers/markets_controller.dart';

class MarketsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MarketsController(), permanent: true);
  }
}
