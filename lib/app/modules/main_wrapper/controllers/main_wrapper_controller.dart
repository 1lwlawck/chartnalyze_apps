import 'package:get/get.dart';

class MainWrapperController extends GetxController {
  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    update();
  }
}
