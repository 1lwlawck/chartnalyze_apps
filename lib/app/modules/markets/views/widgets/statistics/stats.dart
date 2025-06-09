import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MarketStats extends GetView<MarketsController> {
  const MarketStats({super.key});

  /// Menghitung persentase perubahan
  String _getChangePercentage(double? previous, double current) {
    if (previous == null || previous == 0) return '';
    final change = ((current - previous) / previous) * 100;
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  /// Menentukan warna teks perubahan
  Color _getChangeColor(double? previous, double current) {
    if (previous == null || previous == 0) return Colors.grey;
    return current >= previous ? Colors.green : Colors.red;
  }

  /// Widget statistik
  Widget _statBox(
    String title,
    String value,
    String change,
    Color color, {
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center semua isi
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.primaryGreen),
          const SizedBox(height: 6),
        ],
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontFamily: AppFonts.circularStd,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: AppFonts.circularStd,
          ),
        ),
        if (change.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: AppFonts.circularStd,
            ),
          ),
        ],
      ],
    );
  }

  /// Garis vertikal pemisah antar stat
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
    return Obx(() {
      final isLoading = controller.isGlobalMarketLoading.value;
      final data = controller.marketData.value;

      if (isLoading) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SpinKitWave(color: AppColors.primaryGreen, size: 20),
          ),
        );
      }

      if (data == null) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('️ Failed to load market stats')),
        );
      }

      // Format angka
      final marketCapStr =
          '\$${(data.totalMarketCap / 1e12).toStringAsFixed(2)}T';
      final volumeStr = '\$${(data.totalVolume / 1e12).toStringAsFixed(2)}T';
      final dominanceStr = '${data.btcDominance.toStringAsFixed(2)}%';

      final marketCapChange = _getChangePercentage(
        data.previousMarketCap,
        data.totalMarketCap,
      );
      final volumeChange = _getChangePercentage(
        data.previousVolume,
        data.totalVolume,
      );

      final marketCapColor = _getChangeColor(
        data.previousMarketCap,
        data.totalMarketCap,
      );
      final volumeColor = _getChangeColor(
        data.previousVolume,
        data.totalVolume,
      );

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _statBox(
                  'Market Cap',
                  marketCapStr,
                  marketCapChange,
                  marketCapColor,
                ),
              ),
              _verticalDivider(),
              Expanded(
                child: _statBox('Volume', volumeStr, volumeChange, volumeColor),
              ),
              _verticalDivider(),
              Expanded(
                child: _statBox('Dominance', dominanceStr, '', Colors.grey),
              ),
            ],
          ),
        ),
      );
    });
  }
}
