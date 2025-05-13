import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/helpers/number_format_helper.dart';
import 'package:flutter/material.dart';

class ChangeIndicator extends StatelessWidget {
  final double value;
  const ChangeIndicator({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: isPositive ? AppColors.primaryGreen : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 2),
        Text(
          NumberFormatHelper.percent(value.abs()),
          style: TextStyle(
            color: isPositive ? AppColors.primaryGreen : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
