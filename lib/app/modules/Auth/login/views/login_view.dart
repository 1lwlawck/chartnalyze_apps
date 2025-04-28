import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Color(0xFF0B5E4F),
            size: 40,
          ),
          onPressed: () {
            Get.offNamed(Routes.REGISTER);
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
              // Sign in Text
              Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NextTrial',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Welcome back! Please sign in to continue.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B5E4F),
                  fontFamily: 'CircularStd',
                ),
              ),
              SizedBox(height: 20),
              // Email input field
              CustomTextField(
                controller: controller.emailController,
                label: 'Your email address',
                obscureText: false,
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
                      width: 20,
                      height: 20,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Remember me checkbox

              SizedBox(height: 20),
              // Sign in button
              ElevatedButton(
                onPressed: controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5E4F),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial',
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Forgot Password and Register Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.FORGOT_PASSWORD);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'NextTrial',
                      ),
                    ),
                  ),
                  Text(
                    "or",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NextTrial',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.REGISTER);
                      Get.delete<LoginController>();
                    },
                    child: Text(
                      "Register Here",
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
            ],
          ),
        ),
      ),
    );
  }
}
