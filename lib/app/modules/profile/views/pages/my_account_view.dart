// File: views/my_account_view.dart
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/myAccount/account_appbar.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/myAccount/profile_tab.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/myAccount/security_tab.dart';

class MyAccountView extends StatelessWidget {
  MyAccountView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AccountAppBar(context),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              key: Key('loading_indicator'),
              child: SpinKitWave(color: AppColors.primaryGreen, size: 20.0),
            );
          }
          if (controller.user.value.id.isEmpty) {
            return const Center(
              key: Key('user_not_found'),
              child: Text("User not found"),
            );
          }
          return TabBarView(
            children: [
              ProfileTab(
                user: controller.user.value,
                emailController: controller.emailController,
                nameController: controller.nameController,
                usernameController: controller.usernameController,
                birthController: controller.birthDateController,
                onUpdatePressed: () async {
                  final success = await controller.updateSelfProfile();
                  if (success) {
                    Get.snackbar("Success", "Profile updated");
                  } else {
                    Get.snackbar("Error", "Please fill all fields");
                  }
                },

                key: const Key('profile_tab'),
                onLogoutPressed: () => controller.logout(),
                onRefresh: () => controller.fetchUserProfile(),
              ),

              const SecurityTab(key: Key('security_tab')),
            ],
          );
        }),
      ),
    );
  }
}
