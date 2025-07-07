import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:chartnalyze_apps/app/helpers/img_url.dart';
import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/pages/create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePostCard extends StatelessWidget {
  final PostModel post;
  final UserModel user;

  const ProfilePostCard({super.key, required this.post, required this.user});

  @override
  Widget build(BuildContext context) {
    final time = post.createdAt.substring(0, 10);
    final handle = '@${user.username}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.avatarUrl == null || user.avatarUrl!.isEmpty
                      ? 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(user.name ?? "Anonymous")}&size=120'
                      : replaceLocalhost(user.avatarUrl!),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'No Name',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '$handle • $time',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: AppFonts.circularStd,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPopupMenu(context),
            ],
          ),

          const SizedBox(height: 15),

          // Title
          if (post.title != null && post.title!.isNotEmpty) ...[
            Text(
              post.title!,
              style: GoogleFonts.newsreader(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Body
          Text(post.body, style: GoogleFonts.aBeeZee(fontSize: 13)),

          // Image (if any)
          if (post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                replaceLocalhost(post.imageUrls.first),
                fit: BoxFit.cover,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(Icons.remove_red_eye_outlined, '0'),
              _buildStat(Icons.comment_outlined, '${post.commentCount}'),
              _buildStat(Icons.repeat, '0'),
              _buildStat(Icons.favorite_border, '${post.likeCount}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: Colors.grey[500]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 6,
      onSelected: (value) async {
        if (value == 'edit') {
          controller.titleController.text = post.title ?? '';
          controller.bodyController.text = post.body;
          controller.selectedImages.clear();
          controller.editingPostId.value = post.id;
          Get.to(() => CreatePostView(postToEdit: post));
        } else if (value == 'delete') {
          await controller.deletePost(post.id);
        }
      },

      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20, color: Colors.black54),
                  SizedBox(width: 10),
                  Text('Edit', style: GoogleFonts.aBeeZee(fontSize: 14)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                  SizedBox(width: 10),
                  Text(
                    'Delete',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }

  Widget _buildStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontFamily: AppFonts.circularStd,
          ),
        ),
      ],
    );
  }
}
