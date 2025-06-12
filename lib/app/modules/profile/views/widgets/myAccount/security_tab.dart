import 'package:chartnalyze_apps/app/modules/profile/views/pages/update_email_view.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/pages/update_password_view.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/pages/user_activity_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityTab extends StatelessWidget {
  const SecurityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildSecurityItem(
              icon: Icons.alternate_email_rounded,
              label: 'Change Email',
              onTap: () => Get.to(() => UpdateEmailView()),
            ),
            const Divider(height: 1),
            _buildSecurityItem(
              icon: Icons.lock_outline_rounded,
              label: 'Change Password',
              onTap: () => Get.to(() => UpdatePasswordView()),
            ),
            const Divider(height: 1),
            _buildSecurityItem(
              icon: Icons.history_edu_rounded,
              label: 'User Activity',
              onTap: () => Get.to(() => UserActivityView()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
