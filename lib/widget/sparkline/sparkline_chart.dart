import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class SparklineWidget extends StatelessWidget {
  /// Data untuk chart (misal: [1.0, 1.2, 0.9, ...])
  final List<double> data;

  /// Jika true, garis berwarna hijau; jika false, merah
  final bool positive;

  /// Ukuran tinggi dan lebar chart (optional, default 18×60)
  final double height;
  final double width;

  const SparklineWidget({
    Key? key,
    required this.data,
    required this.positive,
    this.height = 18,
    this.width = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Sparkline(
        data: data,
        lineColor: positive ? Colors.green : Colors.red,
        lineWidth: 1.5,
        fillMode: FillMode.none,
      ),
    );
  }
}
