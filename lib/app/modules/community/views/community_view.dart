import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Community',
          style: TextStyle(
            fontFamily: AppFonts.nextTrial,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: AppColors.primaryGreen,
          ),
        ),
        centerTitle: false,
        actions: const [
          Icon(Icons.diamond_outlined, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.isUserLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            final user = controller.getUser(post.userId);

            return _buildCommunityPost(
              username: user?.name ?? 'Loading...',
              handle: '@${user?.username ?? 'unknown'}',
              time: post.createdAt.substring(0, 10),
              content: post.body,
              image: post.imageUrls.isNotEmpty ? post.imageUrls.first : null,
              likes: post.likeCount,
              views: '0',
              comments: post.commentCount,
              reposts: 0,
            );
          },
        );
      }),
    );
  }

  Widget _buildCommunityPost({
    required String username,
    required String handle,
    required String time,
    required String content,
    String? image,
    required int likes,
    required String views,
    required int comments,
    required int reposts,
  }) {
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
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.nextTrial,
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
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),

          const SizedBox(height: 10),

          // Content
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFonts.circularStd,
            ),
          ),

          if (image != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(image),
            ),
          ],

          const SizedBox(height: 12),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(icon: Icons.remove_red_eye_outlined, label: views),
              _buildStat(icon: Icons.comment_outlined, label: '$comments'),
              _buildStat(icon: Icons.repeat, label: '$reposts'),
              _buildStat(icon: Icons.favorite_border, label: '$likes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required IconData icon, required String label}) {
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
