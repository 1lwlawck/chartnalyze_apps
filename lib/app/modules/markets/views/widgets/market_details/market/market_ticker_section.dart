import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/market/market_ticker_row.dart';

class MarketTickerSection extends StatelessWidget {
  final List<TickerModel> tickers;
  const MarketTickerSection({super.key, required this.tickers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tableHeader(),
        const Divider(height: 1),
        ...tickers.map((ticker) => MarketTickerRow(ticker: ticker)),
      ],
    );
  }

  Widget _tableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: const [
          Expanded(
            flex: 3,
            child: Text(
              'Exchange/Pair',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Price',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '24H VOL',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              'Trust',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
