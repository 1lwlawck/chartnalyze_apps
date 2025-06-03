import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/TickerModel.dart';

class MarketTickerRow extends StatelessWidget {
  final TickerModel ticker;

  const MarketTickerRow({required this.ticker});

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return InkWell(
      onTap: () => _showTickerDetailBottomSheet(context, ticker),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
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

                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${ticker.base}/${ticker.target}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
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
                style: GoogleFonts.aBeeZee(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                format.format(ticker.volume),
                style: GoogleFonts.aBeeZee(
                  fontSize: 13,
                  color: Colors.grey[700],
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
                      backgroundImage: NetworkImage(ticker.exchangeLogo),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ticker.marketName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBox('BASE PRICE', format.format(ticker.price)),
                    _infoBox(
                      'TARGET PRICE',
                      '${ticker.price} ${ticker.target}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoBox('BASE VOLUME', format.format(ticker.volume)),
                    _infoBox('TRUST SCORE', _trustLabel(ticker.trustScore)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text(
                      'View on Exchange',
                      style: TextStyle(fontSize: 14),
                      selectionColor: Colors.white,
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
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
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
