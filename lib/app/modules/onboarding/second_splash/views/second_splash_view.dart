import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/second_splash_controller.dart';

class SecondSplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SecondSplashController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildPaginationDot(isActive: false),
              SizedBox(width: 8),
              buildPaginationDot(isActive: true),
              SizedBox(width: 8),
              buildPaginationDot(isActive: false),
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
          Text(
            'Multi-Assets Coverage',
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
            'Track stocks, crypto, and global indices in one powerful dashboard.',
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
              onPressed: ctrl.nextPage,
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
