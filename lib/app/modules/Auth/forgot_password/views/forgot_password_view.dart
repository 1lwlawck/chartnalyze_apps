import 'package:chartnalyze_apps/app/modules/Auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/widget/CustomTextField.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        // ubah dari 10 menjadi 20 atau 24
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'NextTrial',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We will send a code to your email for verification.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF0B5E4F),
                fontFamily: 'CircularStd',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            CustomTextField(
              controller: controller.emailController,
              label: 'Your email address',
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.sendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5E4F),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Get code',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial',
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
