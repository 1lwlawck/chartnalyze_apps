import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:chartnalyze_apps/app/helpers/img_url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class CommunityPostCard extends StatelessWidget {
  final PostModel post;
  final UserModel? user;

  const CommunityPostCard({super.key, required this.post, required this.user});

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          const SizedBox(height: 15),
          Text(post.body, style: GoogleFonts.inter(fontSize: 13)),
          if (post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrls.first),
            ),
          ],
          const SizedBox(height: 12),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final username = user?.name ?? 'Loading...';
    final handle = '@${user?.username ?? 'unknown'}';
    final time = post.createdAt.substring(0, 10);

    final avatarUrl =
        (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
            ? 'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(user?.name ?? "Anonymous")}&size=120'
            : replaceLocalhost(user!.avatarUrl!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
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
        Icon(Icons.more_horiz, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat(Icons.remove_red_eye_outlined, '0'),
        _buildStat(Icons.comment_outlined, '${post.commentCount}'),
        _buildStat(Icons.repeat, '0'),
        _buildStat(Icons.favorite_border, '${post.likeCount}'),
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
