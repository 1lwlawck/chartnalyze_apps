import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Icarius.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.nextTrial,
                      ),
                    ),
                    Text(
                      '@1lwlawck',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: AppFonts.circularStd,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Joined in Feb 2024',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.circularStd,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text(
                '12 ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text('Following', style: TextStyle(fontSize: 13)),
              SizedBox(width: 16),
              Text(
                '1 ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text('Followers', style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
