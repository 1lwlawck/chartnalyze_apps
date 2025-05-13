import 'package:chartnalyze_apps/app/data/models/CoinModel.dart';
import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';

class SearchResultTile extends StatelessWidget {
  final CoinModel coin;

  const SearchResultTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final change = coin.change24h;
    final isUp = change >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(coin.icon), radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              coin.symbol,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: AppFonts.nextTrial,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${coin.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.circularStd,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 18,
                    color: isUp ? Colors.green : Colors.red,
                  ),
                  Text(
                    '${change.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isUp ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.circularStd,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
