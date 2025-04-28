// lib/modules/success_verification/views/success_verification_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/email_verification_controller.dart';

class SuccessVerificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EmailVerificationController>();

    return Scaffold(
      backgroundColor: Color(0xFF0B5E4F),
      body: SafeArea(
        child: Center(
          // Pusatkan keseluruhan kolom
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gambar kustom Anda
                Image.asset(
                  'assets/images/verified_image.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: 40),
                Text(
                  'Email verified',
                  style: TextStyle(
                    fontFamily: 'NextTrial',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your email address ${ctrl.email.value} has been verified\nand successfully registered',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NextTrial',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF0B5E4F),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: 'NextTrial',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
