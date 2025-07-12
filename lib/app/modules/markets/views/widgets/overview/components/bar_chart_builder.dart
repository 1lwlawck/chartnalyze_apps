import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TopGaninersLosers.dart';

class TopGainersLosersBarChart extends StatelessWidget {
  final List<GainerLoserItem> items;

  const TopGainersLosersBarChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final topItems = items.take(10).toList();
    final maxReturn = topItems
        .map((e) => e.returnPct.abs())
        .fold(0.0, (a, b) => a > b ? a : b);

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: const TextStyle(fontSize: 10),
      ),
      primaryYAxis: NumericAxis(
        minimum: -maxReturn - 5,
        maximum: maxReturn + 5,
        interval: (maxReturn / 2).ceilToDouble(),
        majorGridLines: MajorGridLines(width: 0.5, color: Colors.grey.shade300),
        labelStyle: const TextStyle(fontSize: 10),
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: '',
        format: 'point.x : point.y%',
      ),
      series: <CartesianSeries>[
        ColumnSeries<GainerLoserItem, String>(
          dataSource: topItems,
          xValueMapper: (item, _) => item.symbol,
          yValueMapper: (item, _) => item.returnPct,
          pointColorMapper:
              (item, _) => item.returnPct >= 0 ? Colors.green : Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }
}
