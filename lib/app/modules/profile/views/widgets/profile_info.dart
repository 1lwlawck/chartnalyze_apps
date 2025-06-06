import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final user = controller.user.value;

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : const AssetImage(NoProfileImage.noProfileImage)
                              as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.nextTrial,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: AppFonts.circularStd,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        user.formattedCreatedAt,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppFonts.circularStd,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${controller.followeds.length} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: AppFonts.nextTrial,
                  ),
                ),
                const Text(
                  'Following',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: AppFonts.circularStd,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${controller.followers.length} ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: AppFonts.nextTrial,
                  ),
                ),
                const Text(
                  'Followers',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: AppFonts.circularStd,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
