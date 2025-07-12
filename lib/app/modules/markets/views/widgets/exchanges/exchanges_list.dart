import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/exchanges/exchanges_row_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/modules/markets/controllers/markets_controller.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/ExchangeModel.dart';

class ExchangesListView extends GetView<MarketsController> {
  const ExchangesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketsController>().exchanges;

    return Obx(() {
      final List<ExchangeModel> exchanges = controller.exchanges;

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (exchanges.isEmpty) {
        return const Center(child: Text('No exchanges available.'));
      }

      return Column(
        children: [
          _tableHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: exchanges.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final exchange = exchanges[index];
                return ExchangeRowTile(exchange: exchange, index: index + 1);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _tableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: const [
          SizedBox(
            width: 20,
            child: Text(
              '#',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              'Exchange',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Reported Volume',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Trust',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
