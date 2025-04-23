import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/first_splash_controller.dart';

class FirstSplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<FirstSplashController>();

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
                'assets/images/dollars_coin.png',
                width: 400,
                height: 350,
              ),
            ],
          ),
          SizedBox(height: 70),

          // Teks konten
          Text(
            'Smart insights, better decisions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0B5E4F),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'NextTrial',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Get real-time analysis and trends\nto stay ahead in the market.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              fontFamily: 'NextTrial',
            ),
          ),
          Spacer(),

          Padding(
            padding: EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                Get.toNamed(Routes.SECOND_SPLASH);
              },
              child: Text(
                'Next Page',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B5E4F),
                  decoration: TextDecoration.underline,
                  fontFamily: 'NextTrial',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
