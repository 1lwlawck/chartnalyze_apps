import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Icarius.',
                    style: TextStyle(
                      fontFamily: AppFonts.nextTrial,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '@1lwlawck',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: AppFonts.circularStd,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Joined in Feb 2024',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: AppFonts.circularStd,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_border,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text(
                        'Pinned Watchlist',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: AppFonts.circularStd,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz, size: 18),
                        label: const Text("Edit Profile"),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Tabs
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryGreen,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.circularStd,
                ),
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Comments'),
                  Tab(text: 'Reactions'),
                ],
              ),
            ),

            // Tab Views (Empty States)
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmptyState(),
                  _buildEmptyState(),
                  _buildEmptyState(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty-post.png',
            height: 120,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nothing to see here!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.nextTrial,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You haven\'t posted anything yet. Start sharing your thoughts or explore the community!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontFamily: AppFonts.circularStd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
