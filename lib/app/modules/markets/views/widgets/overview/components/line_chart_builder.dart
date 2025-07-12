import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/NormalizedPricePoint.dart';

class NormalizedLineChart extends StatelessWidget {
  final Map<String, List<NormalizedPricePoint>> dataMap;

  const NormalizedLineChart({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    final List<CartesianSeries<dynamic, dynamic>> seriesList = [];

    final colorPalette = <Color>[
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.deepPurple,
    ];

    int colorIndex = 0;
    for (final entry in dataMap.entries) {
      seriesList.add(
        LineSeries<dynamic, dynamic>(
          name: entry.key,
          dataSource: entry.value,
          xValueMapper: (p, _) => p.scrapedAt,
          yValueMapper: (p, _) => p.normalizedPrice,
          width: 2,
          color: colorPalette[colorIndex % colorPalette.length],
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      );
      colorIndex++;
    }

    return SizedBox(
      height: 320,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0.5),
          dateFormat: DateFormat.MMMd(),
          intervalType: DateTimeIntervalType.days,
          interval: 7,
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelStyle: const TextStyle(fontSize: 10),
        ),

        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorGridLines: MajorGridLines(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
          labelStyle: const TextStyle(fontSize: 9),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          canShowMarker: true,
          format: 'point.x : point.y',
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
          zoomMode: ZoomMode.x,
        ),
        series: seriesList,
      ),
    );
  }
}
