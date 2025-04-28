import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/widget/CustomTextField.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Color(0xFF0B5E4F),
            size: 40,
          ),
          onPressed: () {
            Get.offNamed(Routes.THIRD_SPLASH);
            Get.delete<RegisterController>();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Register',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NextTrial',
                ),
              ),
              Text(
                'Create a new account to get started.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B5E4F),
                  fontFamily: 'CircularStd',
                ),
              ),
              SizedBox(height: 30),
              // Username input field
              CustomTextField(
                controller: controller.usernameController,
                label: 'Username',
                obscureText: false,
              ),
              SizedBox(height: 20),
              // Email input field
              CustomTextField(
                controller: controller.emailController,
                label: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              // Password input field
              Obx(
                () => CustomTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      controller.isPasswordVisible.value
                          ? 'assets/images/eye 1.png'
                          : 'assets/images/eye-off 1.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Confirm Password input field
              Obx(
                () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Image.asset(
                      controller.isConfirmPasswordVisible.value
                          ? 'assets/images/eye 1.png'
                          : 'assets/images/eye-off 1.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Register button
              ElevatedButton(
                onPressed: controller.register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5E4F),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial',
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Already have an account text
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: Text(
                  "Already have an account? Sign in here",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B5E4F),
                    fontFamily: 'NextTrial',
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
