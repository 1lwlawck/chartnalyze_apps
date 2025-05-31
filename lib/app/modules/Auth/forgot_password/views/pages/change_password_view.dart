import 'package:chartnalyze_apps/app/constants/strings.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/widgets/text_field/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/modules/Auth/forgot_password/controllers/forgot_password_controller.dart';

class ChangePasswordView extends GetView<ForgotPasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 50,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryGreen,
            size: 40,
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
                  AppStrings.resetPasswordTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.nextTrial,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.resetPasswordInstruction,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryGreen,
                    fontFamily: AppFonts.nextTrial,
                  ),
                ),
                const SizedBox(height: 32),

                // New Password Field
                Obx(
                  () => CustomTextField(
                    label: AppStrings.password,
                    controller: controller.newPasswordController,
                    obscureText: !controller.isNewPasswordVisible.value,
                    suffixIcon: IconButton(
                      icon: Image.asset(
                        controller.isNewPasswordVisible.value
                            ? 'assets/images/password-icons/eye 1.png'
                            : 'assets/images/password-icons/eye-off 1.png',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: controller.toggleNewPasswordVisibility,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                Obx(
                  () => CustomTextField(
                    label: AppStrings.confirmPassword,
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
                  ),
                ),
                const SizedBox(height: 24),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final password =
                          controller.newPasswordController.text.trim();
                      final confirmPassword =
                          controller.confirmPasswordController.text.trim();

                      if (password.isEmpty || confirmPassword.isEmpty) {
                        Get.snackbar('Error', 'Password cannot be empty');
                        return;
                      }

                      if (password.length < 6) {
                        Get.snackbar('Error', 'Password too short');
                        return;
                      }

                      if (password != confirmPassword) {
                        Get.snackbar('Error', 'Passwords do not match');
                        return;
                      }

                      controller.updatePassword();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      AppStrings.updatePasswordButton,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.nextTrial,
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
