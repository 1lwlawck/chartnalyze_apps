import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoinHighlightCard extends StatelessWidget {
  final String symbol;
  final String name;
  final String imageUrl;
  final double change;

  const CoinHighlightCard({
    super.key,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              imageUrl,
              width: 28,
              height: 28,
              errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: change >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
