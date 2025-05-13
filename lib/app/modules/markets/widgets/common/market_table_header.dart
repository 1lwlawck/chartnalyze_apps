import 'package:flutter/material.dart';

class MarketTableHeader extends StatelessWidget {
  const MarketTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          // Index #
          SizedBox(
            width: 24,
            child: Text(
              '#',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Icon spacing
          SizedBox(width: 6),
          // Market Cap (icon + symbol + cap)
          Expanded(
            flex: 2,
            child: Text(
              'Market Cap',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Price
          Expanded(
            flex: 3,
            child: Text(
              'Price',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 24h Change
          Expanded(
            flex: 3,
            child: Text(
              '24h',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 7d Change
          Expanded(
            flex: 3,
            child: Text(
              '7d',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
