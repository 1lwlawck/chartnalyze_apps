import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_empty_view.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_fab.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_info.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.circularStd,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          backgroundColor: AppColors.primaryGreen,
          elevation: 0.5,
        ),
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Column(
            children: [
              ProfileInfo(),
              ProfileTabs(),
              Expanded(child: ProfileEmptyView()),
            ],
          );
        }),

        floatingActionButton: const ProfileExpandableFAB(),
      ),
    );
  }
}
