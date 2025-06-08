import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
                GestureDetector(
                  onTap: controller.pickAndUploadAvatar,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Obx(() {
                        if (controller.isUploadingAvatar.value) {
                          return const SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        return CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            (user.avatarUrl ?? '')
                                    .replaceFirst('localhost', '192.168.69.214')
                                    .isEmpty
                                ? 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(user.name ?? "Anonymous")}&size=120'
                                : user.avatarUrl!.replaceFirst(
                                  'localhost',
                                  '192.168.69.214',
                                ),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        user.formattedCreatedAt,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 12,
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
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Following',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${controller.followers.length} ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Followers',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
