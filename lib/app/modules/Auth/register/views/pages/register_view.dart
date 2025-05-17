import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:chartnalyze_apps/widgets/button/CustomButton.dart';
import 'package:chartnalyze_apps/widgets/text_field/CustomTextField.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';
import '../../controllers/register_controller.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryGreen,
            size: 40,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                AppStrings.register,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontFamily: AppFonts.nextTrial,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.createAccount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                  fontFamily: AppFonts.circularStd,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: controller.usernameController,
                label: AppStrings.username,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.emailController,
                label: AppStrings.email,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextField(
                  controller: controller.passwordController,
                  label: AppStrings.password,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      controller.isPasswordVisible.value
                          ? AppImages.eyeOpen
                          : AppImages.eyeClosed,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  label: AppStrings.confirmPassword,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      controller.isConfirmPasswordVisible.value
                          ? AppImages.eyeOpen
                          : AppImages.eyeClosed,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Obx(
                () => CustomButton(
                  text: AppStrings.register,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.offNamed(Routes.LOGIN),
                  child: RichText(
                    text: const TextSpan(
                      text: AppStrings.alreadyHaveAccount,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.nextTrial,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.signInHere,
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
