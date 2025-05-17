import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/third_splash_controller.dart';

class ThirdSplashView extends StatelessWidget {
  const ThirdSplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ThirdSplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 60),

          // Pagination dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPaginationDot(isActive: false),
              SizedBox(width: 8),
              buildPaginationDot(isActive: false),
              SizedBox(width: 8),
              buildPaginationDot(isActive: true),
            ],
          ),
          SizedBox(height: 100),

          // Image
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/third_splash.png',
                width: 400,
                height: 400,
              ),
            ],
          ),
          SizedBox(height: 40),

          // Content text
          Text(
            'AI-Powered Predictions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B5E4F),
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'NextTrial',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Make smarter moves with intelligent forecasts and data-driven suggestions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
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
                  onPressed: ctrl.navigateToRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5E4F),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20), // Space between buttons

                // Sign In Button
                ElevatedButton(
                  onPressed: ctrl.navigateToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5E4F),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  // Pagination dot builder
  Widget buildPaginationDot({required bool isActive}) {
    return Container(
      width: 20,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF0B5E4F) : Color(0xFFD9E6E1),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
