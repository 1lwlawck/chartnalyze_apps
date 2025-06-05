import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/ExchangeModel.dart';

class ExchangeRowTile extends StatelessWidget {
  final ExchangeModel exchange;
  final int index;

  const ExchangeRowTile({
    super.key,
    required this.exchange,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(exchange.image),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exchange.name,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              // overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              format.format(exchange.tradeVolume24hBtc),
              textAlign: TextAlign.right,
              style: GoogleFonts.aBeeZee(fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          _trustScoreTag(exchange.trustScore),
        ],
      ),
    );
  }

  Widget _trustScoreTag(int score) {
    // Warna latar belakang berdasarkan skor
    Color backgroundColor;
    Color textColor;

    if (score >= 9) {
      backgroundColor = AppColors.primaryGreen;
      textColor = Colors.greenAccent;
    } else if (score >= 7) {
      backgroundColor = Colors.greenAccent;
      textColor = Colors.green;
    } else {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$score/10',
        style: GoogleFonts.aBeeZee(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
