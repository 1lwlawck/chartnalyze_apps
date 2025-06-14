import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/OHLCDataModel.dart';

class MarketChart extends StatelessWidget {
  final List<OHLCDataModel> ohlcData;
  final String interval;

  const MarketChart({
    super.key,
    required this.ohlcData,
    required this.interval,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIntraday = interval == '1 day';
    final DateFormat axisFormat =
        isIntraday ? DateFormat.Hm() : DateFormat.MMMd();

    return Container(
      height: 300,
      width: double.maxFinite,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          SfCartesianChart(
            plotAreaBorderWidth: 0,
            tooltipBehavior: TooltipBehavior(
              enable: true,
              elevation: 0,
              canShowMarker: false,
              builder: (dynamic data, _, __, ___, ____) {
                final OHLCDataModel d = data;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.yMMMd().add_Hm().format(d.time),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${d.close.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            primaryXAxis: DateTimeAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              majorGridLines: const MajorGridLines(width: 0),
              dateFormat: axisFormat,
              axisLine: const AxisLine(width: 0),
              labelStyle: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
            primaryYAxis: NumericAxis(
              opposedPosition: true,
              anchorRangeToVisiblePoints: true,
              desiredIntervals: 5,
              axisLine: const AxisLine(width: 0),
              majorGridLines: MajorGridLines(
                width: 0.5,
                color: Colors.grey.shade300,
              ),
              labelStyle: const TextStyle(
                fontSize: 7,
                fontFamily: AppFonts.circularStd,
                color: Colors.grey,
              ),
              numberFormat: NumberFormat.currency(
                locale: 'en_US',
                symbol: 'US\$',
                decimalDigits: 0,
              ),
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              zoomMode: ZoomMode.x,
              enableMouseWheelZooming: true,
            ),
            series: <CandleSeries<OHLCDataModel, DateTime>>[
              CandleSeries(
                dataSource: ohlcData,
                xValueMapper: (d, _) => d.time,
                lowValueMapper: (d, _) => d.low,
                highValueMapper: (d, _) => d.high,
                openValueMapper: (d, _) => d.open,
                closeValueMapper: (d, _) => d.close,
                bearColor: AppColors.errorRed,
                bullColor: AppColors.primaryGreen,
                borderWidth: 1.4,
                enableSolidCandles: true,
                name: 'Price',
              ),
            ],
          ),

          // Tambahkan logo CoinGecko di kanan atas
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: 0.7,
                child: Image.asset(
                  'assets/images/coingecko-seeklogo.png',
                  width: 80,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
