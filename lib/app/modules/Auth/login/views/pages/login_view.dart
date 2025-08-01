import 'package:chartnalyze_apps/app/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/widgets/text_field/CustomTextField.dart';
import 'package:chartnalyze_apps/widgets/button/CustomButton.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/constants/strings.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/login_controller.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.primaryGreen,
            size: 40,
          ),
          key: const Key('backButtonOnLoginView'),
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
              Text(
                AppStrings.signIn,
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.welcomeBack,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                  fontFamily: AppFonts.circularStd,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                key: const Key('emailTextFieldOnLoginView'),
                controller: controller.emailController,
                suffixIcon: const Icon(
                  Icons.email_outlined,

                  color: AppColors.primaryGreen,
                ),
                label: 'Your email address',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomTextField(
                  key: const Key('passwordTextFieldOnLoginView'),
                  controller: controller.passwordController,
                  label: AppStrings.password,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      controller.isPasswordVisible.value
                          ? PasswordIcons.eye
                          : PasswordIcons.eyeOff,
                      width: 20,
                      height: 20,
                      color: AppColors.primaryGreen,
                    ),
                    key: const Key('togglePasswordVisibilityButtonOnLoginView'),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('forgotPasswordButtonOnLoginView'),
                  onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                  child: const Text(
                    AppStrings.forgotPassword,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                      fontFamily: AppFonts.nextTrial,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => CustomButton(
                  text: AppStrings.signIn,
                  isLoading: controller.isLoading.value,
                  key: const Key('loginButtonOnLoginView'),
                  onPressed: controller.login,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    AppStrings.dontHaveAccount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: AppFonts.circularStd,
                    ),
                  ),
                  TextButton(
                    key: const Key('registerButtonOnLoginView'),
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    child: const Text(
                      AppStrings.registerHere,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                        fontFamily: AppFonts.nextTrial,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
