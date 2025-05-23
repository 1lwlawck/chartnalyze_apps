import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: AppColors.primaryGreen,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.circularStd,
      ),
      tabs: [Tab(text: 'Posts'), Tab(text: 'Comments'), Tab(text: 'Reactions')],
    );
  }
}
