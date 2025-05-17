// lib/app/modules/onboarding/controllers/onboarding_controller.dart
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void navigateToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  void navigateToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  Widget buildDots(int activeIndex) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive =
              currentPage.value == index; // langsung observasi di sini
          return Container(
            width: 20,
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color:
                  isActive ? const Color(0xFF0B5E4F) : const Color(0xFFD9E6E1),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      );
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
