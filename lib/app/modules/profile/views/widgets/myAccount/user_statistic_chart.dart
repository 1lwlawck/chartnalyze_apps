import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserStatisticsChart extends StatelessWidget {
  final Map<String, int> data;

  const UserStatisticsChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final colors = [
      Colors.blueAccent,
      Colors.deepOrangeAccent,
      Colors.lightGreen,
      Colors.purpleAccent,
      Colors.teal,
      Colors.amber,
    ];

    final total = data.values.isEmpty ? 0 : data.values.reduce((a, b) => a + b);

    if (total == 0) {
      return Center(
        child: Text(
          "No statistics available.",
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "User Content Statistics",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.2,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50,
                sectionsSpace: 3,
                startDegreeOffset: -90,
                sections:
                    data.entries.mapIndexed((index, entry) {
                      final value = entry.value.toDouble();
                      final percentage = ((value / total) * 100)
                          .toStringAsFixed(1);
                      return PieChartSectionData(
                        value: value,
                        title: "$percentage%",
                        color: colors[index % colors.length],
                        radius: 95,
                        showTitle: true,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 4),
                          ],
                        ),
                        badgeWidget: _BadgeLabel(
                          label: "${entry.key} (${entry.value})",
                          color: colors[index % colors.length],
                        ),
                        badgePositionPercentageOffset: 1.2,
                      );
                    }).toList(),
              ),
              swapAnimationDuration: const Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
          const SizedBox(height: 24),
          // Legend Section
          Wrap(
            spacing: 14,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children:
                data.entries.mapIndexed((index, entry) {
                  return Chip(
                    backgroundColor: colors[index % colors.length].withOpacity(
                      0.15,
                    ),
                    avatar: CircleAvatar(
                      backgroundColor: colors[index % colors.length],
                      radius: 7,
                    ),
                    label: Text(
                      "${entry.key} (${entry.value})",
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BadgeLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _BadgeLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

extension on Iterable {
  Iterable<T> mapIndexed<T>(T Function(int index, dynamic value) f) {
    var index = 0;
    return map((value) => f(index++, value));
  }
}
