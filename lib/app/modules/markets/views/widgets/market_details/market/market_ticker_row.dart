import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';

class MarketTickerRow extends StatelessWidget {
  final TickerModel ticker;

  const MarketTickerRow({super.key, required this.ticker});

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return InkWell(
      onTap: () => _showTickerDetailBottomSheet(context, ticker),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(ticker.exchangeLogo),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticker.marketName,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${ticker.base}/${ticker.target}',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                format.format(ticker.price),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                format.format(ticker.volume),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(width: 30, child: _buildTrustDot(ticker.trustScore)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustDot(String score) {
    Color color;
    switch (score) {
      case 'green':
        color = AppColors.primaryGreen;
        break;
      case 'yellow':
        color = Colors.orange;
        break;
      case 'red':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Center(
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  void _showTickerDetailBottomSheet(BuildContext context, TickerModel ticker) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(ticker.exchangeLogo),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ticker.marketName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _infoBox('Base Price', format.format(ticker.price)),
                    _infoBox(
                      'Target Price',
                      '${ticker.price} ${ticker.target}',
                    ),
                    _infoBox('Base Volume', format.format(ticker.volume)),
                    _infoBox('Trust Score', _trustLabel(ticker.trustScore)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      'View on Exchange',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final url = ticker.tradeUrl;
                      if (url.isNotEmpty) {
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _infoBox(String label, String value) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _trustLabel(String trustScore) {
    switch (trustScore) {
      case 'green':
        return 'Good';
      case 'yellow':
        return 'Fair';
      case 'red':
        return 'Low';
      default:
        return 'Unknown';
    }
  }
}
