import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/second_splash_controller.dart';

class SecondSplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<SecondSplashController>();

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
                  color: Color(0xFF0B5E4F),
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
            ],
          ),
          SizedBox(height: 100),

          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/second_splash.png',
                width: 400,
                height: 350,
              ),
            ],
          ),
          SizedBox(height: 50),

          // Teks konten
          Text(
            'Multi-Assets Coverage',
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
            'Track stocks, crypto, and global indices in one powerful dashboard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              fontFamily: 'NextTrial', // Menetapkan font Next-Trial
            ),
          ),
          Spacer(),

          Padding(
            padding: EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                Get.toNamed(Routes.THIRD_SPLASH);
              },
              child: Text(
                'Next Page',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B5E4F),
                  decoration: TextDecoration.underline,
                  fontFamily: 'NextTrial', // Menetapkan font Next-Trial
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
