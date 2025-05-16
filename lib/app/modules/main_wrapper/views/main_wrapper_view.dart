import 'package:chartnalyze_apps/widgets/navigation_bar/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../community/views/community_view.dart';
import '../../markets/views/markets_view.dart';
import '../../news/views/news_view.dart';
import '../../profile/views/profile_view.dart';
import '../../search/views/search_view.dart';
import '../controllers/main_wrapper_controller.dart';

class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  static final List<Widget> pages = [
    MarketsView(),
    NewsView(),
    SearchView(),
    CommunityView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainWrapperController>(
      builder:
          (_) => Scaffold(
            body: pages[controller.currentIndex],
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: controller.currentIndex,
              onTap: controller.changeTab,
            ),
          ),
    );
  }
}
