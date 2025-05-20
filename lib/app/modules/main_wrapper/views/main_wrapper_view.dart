import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/widgets/navigation_bar/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../community/views/community_view.dart';
import '../../markets/views/pages/markets_view.dart';
import '../../news/views/pages/news_view.dart';
import '../../profile/views/profile_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperView extends StatefulWidget {
  const MainWrapperView({super.key});

  static final List<Widget> pages = [
    MarketsView(),
    NewsView(),
    SearchView(),
    CommunityView(),
    ProfileView(),
  ];

  @override
  State<MainWrapperView> createState() => _MainWrapperViewState();
}

class _MainWrapperViewState extends State<MainWrapperView> {
  DateTime? _lastBackPressTime;

  MainWrapperController get controller => Get.find<MainWrapperController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex != 0) {
          controller.changeTab(0);
          return false;
        }

        // Sudah di tab 0, cek double back
        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primaryGreen,
              content: Text(
                "Press back again to exit",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.circularStd,
                ),
              ),
              duration: const Duration(seconds: 2),
            ),
          );

          return false; // cegah keluar dulu
        }

        return true; // izinkan keluar
      },
      child: GetBuilder<MainWrapperController>(
        builder:
            (_) => Scaffold(
              body: MainWrapperView.pages[controller.currentIndex],
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: controller.currentIndex,
                onTap: controller.changeTab,
              ),
            ),
      ),
    );
  }
}
