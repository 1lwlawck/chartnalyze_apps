import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: AppColors.primaryGreen,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primaryGreen,
      labelStyle: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
      tabs: const [
        Tab(text: 'Posts'),
        Tab(text: 'Comments'),
        Tab(text: 'Reactions'),
      ],
    );
  }
}
