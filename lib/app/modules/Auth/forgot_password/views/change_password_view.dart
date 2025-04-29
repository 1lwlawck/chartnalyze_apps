import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/widget/CustomTextField.dart';
import 'package:chartnalyze_apps/app/modules/Auth/forgot_password/controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 50, // Mengatur lebar leading supaya chevron nempel
        leading: IconButton(
          padding: EdgeInsets.zero, // Hilangkan padding IconButton
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 32, // Ukuran icon biar lebih pas
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Reset your password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the new password you want to use.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0B5E4F),
                    fontFamily: 'NextTrial',
                  ),
                ),
                const SizedBox(height: 32),

                // New Password Field
                Obx(() => CustomTextField(
                      label: 'New Password',
                      controller: controller.newPasswordController,
                      obscureText: !controller.isNewPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          controller.isNewPasswordVisible.value
                              ? 'assets/images/eye 1.png'
                              : 'assets/images/eye-off 1.png',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 16),

                // Confirm Password Field
                Obx(() => CustomTextField(
                      label: 'Confirm Password',
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Image.asset(
                          controller.isConfirmPasswordVisible.value
                              ? 'assets/images/eye 1.png'
                              : 'assets/images/eye-off 1.png',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 24),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B5E4F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      'Update Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NextTrial',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
