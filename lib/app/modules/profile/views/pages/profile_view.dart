import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_empty_view.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_fab.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_info.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/profile_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg-appbar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 180,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Personalize your account and post your any tweets',
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
