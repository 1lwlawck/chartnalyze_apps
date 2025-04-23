import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/third_splash_controller.dart';

class ThirdSplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<ThirdSplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 60),

          // Pagination dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFFD9E6E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFFD9E6E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 20,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF0B5E4F),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),

          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/third_splash.png',
                width: 300,
                height: 350,
              ),
            ],
          ),
          SizedBox(height: 40),

          // Teks konten
          Text(
            'AI-Powered Predictions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B5E4F),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'NextTrial', // Menetapkan font Next-Trial
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Make smarter moves with intelligent forecasts and data-driven suggestions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              fontFamily: 'NextTrial',
            ),
          ),
          SizedBox(height: 90),

          // Button Row (Register & Sign in)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    // Aksi ketika tombol Register ditekan
                    print('Register button pressed');
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5E4F),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 20), // Space between buttons
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.LOGIN);
                    // Aksi ketika tombol Sign In ditekan
                    print('Sign In button pressed');
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5E4F),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
