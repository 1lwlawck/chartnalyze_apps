import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';

class MarketStatisticCard extends StatelessWidget {
  final CoinDetailModel coin;

  const MarketStatisticCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final usdFormat = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    final double range =
        ((coin.price - coin.low24h) / (coin.high24h - coin.low24h)).clamp(0, 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 12),
          // const _ToggleRow(),
          const SizedBox(height: 12),
          const Text(
            'Low / High',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: AppFonts.circularStd,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(usdFormat.format(coin.low24h), style: _smallText),
              Text(usdFormat.format(coin.high24h), style: _smallText),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: range,
            minHeight: 4,
            backgroundColor: Colors.grey[300],
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatGroup(
                  items: [
                    _Stat('Market Cap', usdFormat.format(coin.marketCap)),
                    _Stat('24h Volume', usdFormat.format(coin.totalVolume)),
                    _Stat(
                      'Max Supply',
                      _short(coin.totalSupply ?? 0, coin.symbol),
                    ),
                    _Stat('All-time High', usdFormat.format(coin.high24h)),
                    _Stat('All-time Low', usdFormat.format(coin.low24h)),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: Colors.grey[300],
              ),
              Expanded(
                child: _StatGroup(
                  items: [
                    _Stat(
                      'Circulating Supply',
                      _short(coin.circulatingSupply ?? 0, coin.symbol),
                    ),
                    _Stat(
                      'Total Supply',
                      _short(coin.totalSupply ?? 0, coin.symbol),
                    ),
                    _Stat('Rank', '#${coin.rank}'),
                    _Stat('Market Dominance', '61.37%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final _smallText = const TextStyle(
    fontSize: 13,
    fontFamily: AppFonts.circularStd,
  );

  static String _short(double value, String unit) {
    if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(2)} T $unit';
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(2)} B $unit';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(2)} M $unit';
    return '${value.toStringAsFixed(2)} $unit';
  }
}

/// Widget: Header section
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: AppFonts.circularStd,
          ),
        ),
      ],
    );
  }
}

// /// Widget: Toggle row (24h, 30d, 1y)
// class _ToggleRow extends StatelessWidget {
//   const _ToggleRow();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: const [
//         _Toggle('24h', true),
//         _Toggle('30d', false),
//         _Toggle('1y', false),
//       ],
//     );
//   }
// }

/// Widget: Single toggle button
// class _Toggle extends StatelessWidget {
//   final String label;
//   final bool isActive;

//   const _Toggle(this.label, this.isActive);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//       decoration: BoxDecoration(
//         color: isActive ? Colors.grey[200] : Colors.transparent,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 13,
//           fontFamily: AppFonts.circularStd,
//           fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
// }

/// Widget: Group of stats (left or right column)
class _StatGroup extends StatelessWidget {
  final List<_Stat> items;

  const _StatGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) => e.build()).toList(),
    );
  }
}

/// Model + builder for each stat
class _Stat {
  final String title;
  final String value;

  _Stat(this.title, this.value);

  Widget build() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.circularStd,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFonts.circularStd,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
