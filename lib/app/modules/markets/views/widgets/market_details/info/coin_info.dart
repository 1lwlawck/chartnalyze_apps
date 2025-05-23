import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chartnalyze_apps/app/data/models/CoinDetailModel.dart';

class CoinInfoSection extends StatelessWidget {
  final CoinDetailModel coin;
  const CoinInfoSection({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _infoCard(
          context,
          title: 'Description',
          value: coin.description,
          icon: Icons.description_outlined,
          isMultiline: true,
        ),
        _infoCard(
          context,
          title: 'Hashing Algorithm',
          value: coin.hashingAlgorithm,
          icon: Icons.lock_outline,
        ),
        _infoCard(
          context,
          title: 'Block Time (minutes)',
          value: coin.blockTime.toString(),
          icon: Icons.schedule_outlined,
        ),
        _infoCard(
          context,
          title: 'Genesis Date',
          value: coin.genesisDate,
          icon: Icons.calendar_today_outlined,
        ),
        _linkCard(
          context,
          title: 'Homepage',
          url: coin.homepage,
          icon: Icons.language,
        ),
        _linkCard(
          context,
          title: 'Explorer',
          url: coin.explorer,
          icon: Icons.explore_outlined,
        ),
        _linkCard(
          context,
          title: 'Whitepaper',
          url: coin.whitepaper,
          icon: Icons.picture_as_pdf_outlined,
        ),
        _infoCard(
          context,
          title: 'Categories',
          value: coin.categories.join(', '),
          icon: Icons.category_outlined,
        ),
      ],
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    bool isMultiline = false,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : '-',
          maxLines: isMultiline ? null : 2,
          overflow: isMultiline ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _linkCard(
    BuildContext context, {
    required String title,
    required String url,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle:
            url.isNotEmpty
                ? GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    url,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                : const Text(
                  '-',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
      ),
    );
  }
}
