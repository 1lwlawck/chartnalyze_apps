import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';

class MarketStats extends StatelessWidget {
  const MarketStats({super.key});

  Widget _statBox(String title, String value, String change, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: AppFonts.circularStd,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: AppFonts.circularStd)),
        const SizedBox(height: 4),
        Text(change,
            style: TextStyle(
                color: color, fontSize: 12, fontFamily: AppFonts.circularStd)),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: _statBox('Market Cap', '\$1.56T', '-5.78%', Colors.red)),
            _verticalDivider(),
            Expanded(
                child: _statBox('Volume', '\$1.56T', '-5.78%', Colors.red)),
            _verticalDivider(),
            Expanded(
                child: _statBox('Dominance', '50.46%', 'BTC', Colors.orange)),
          ],
        ),
      ),
    );
  }
}
