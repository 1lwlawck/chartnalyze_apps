import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/data/models/users/UsersActivity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserActivityCard extends StatelessWidget {
  final UserActivity activity;

  const UserActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isLogin = activity.type == 'login';
    final isLogout = activity.type == 'logout';
    final icon =
        isLogin
            ? Icons.login_rounded
            : isLogout
            ? Icons.logout_rounded
            : Icons.verified_user_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm').format(activity.createdAt),
                  style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "IP: ${activity.userIpAddress}",
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.userAgent,
                  style: GoogleFonts.manrope(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              activity.type.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
