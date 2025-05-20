import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
            fontFamily: AppFonts.nextTrial,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontFamily: AppFonts.nextTrial,
          ),
          items: [
            _buildSvgNavItem(NavbarIcons.markets, 'Markets', 0),
            _buildSvgNavItem(NavbarIcons.news, 'News', 1),
            _buildSvgNavItem(NavbarIcons.search, 'Search', 2),
            _buildSvgNavItem(NavbarIcons.community, 'Community', 3),
            _buildSvgNavItem(NavbarIcons.profiles, 'Profile', 4),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildSvgNavItem(
    String asset,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          currentIndex == index ? AppColors.primaryGreen : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
