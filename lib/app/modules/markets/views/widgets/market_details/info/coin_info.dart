import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/modules/markets/views/widgets/market_details/summary/statistic_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinDetailModel.dart';

class CoinInfoSection extends StatelessWidget {
  final CoinDetailModel coin;
  const CoinInfoSection({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    // final allLinks = {
    //   ...coin.homepageLinks,
    //   ...coin.visitorLinks,
    //   ...coin.communityLinks,
    // };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _descriptionTile(coin.description),
        const SizedBox(height: 12),
        MarketStatisticCard(coin: coin),
        const SizedBox(height: 12),
        _infoGridCard(context),
        const SizedBox(height: 20),
        _linkGroupCardGrouped(
          homepageLinks: coin.homepageLinks,
          visitorLinks: coin.visitorLinks,
          communityLinks: coin.communityLinks,
        ),

        const SizedBox(height: 20),
        _sectionTitle('Kategori'),
        _categoryChips(coin.categories),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _descriptionTile(String description) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              collapsedBackgroundColor: Colors.grey.shade50,
              backgroundColor: Colors.grey.shade50,
              collapsedIconColor: Colors.teal,
              iconColor: Colors.teal,
              title: Text(
                'Description',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                  fontSize: 16,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: Text(
                    description.isNotEmpty ? description : '-',
                    style: GoogleFonts.openSans(
                      fontSize: 13.5,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoGridCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _infoTile(
              title: 'Hashing Algorithm',
              value: coin.hashingAlgorithm,
              icon: FontAwesomeIcons.lock,
              color: Colors.indigo,
            ),
            _infoTile(
              title: 'Block Time',
              value: '${coin.blockTime} min',
              icon: FontAwesomeIcons.clock,
              color: Colors.orange,
            ),
            _infoTile(
              title: 'Genesis Date',
              value: coin.genesisDate,
              icon: FontAwesomeIcons.calendar,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkGroupCardGrouped({
    required Map<String, String> homepageLinks,
    required Map<String, String> visitorLinks,
    required Map<String, String> communityLinks,
  }) {
    return Card(
      elevation: 0.8,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Links',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 16),

            /// Website Section
            if (homepageLinks.isNotEmpty) ...[
              Text(
                'Website',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    homepageLinks.entries.map((entry) {
                      return _buildLinkChip(entry.key, entry.value);
                    }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            /// Explorers Section
            if (visitorLinks.isNotEmpty) ...[
              Text(
                'Explorers',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    visitorLinks.entries.map((entry) {
                      return _buildLinkChip(entry.key, entry.value);
                    }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            /// Community Section
            if (communityLinks.isNotEmpty) ...[
              Text(
                'Community',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    communityLinks.entries.map((entry) {
                      return _buildLinkChip(entry.key, entry.value);
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLinkChip(String name, String url) {
    final uri = Uri.tryParse(url);
    final icon = _getIconFor(name.toLowerCase());

    return ActionChip(
      label: Text(name),
      avatar: FaIcon(icon, size: 16, color: Colors.teal),
      onPressed: () async {
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      backgroundColor: Colors.grey.shade100,
      labelStyle: GoogleFonts.notoSans(color: Colors.black87, fontSize: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  IconData _getIconFor(String name) {
    if (name.contains('twitter')) return FontAwesomeIcons.twitter;
    if (name.contains('facebook')) return FontAwesomeIcons.facebook;
    if (name.contains('reddit')) return FontAwesomeIcons.reddit;
    if (name.contains('bitcointalk')) return FontAwesomeIcons.comments;
    if (name.contains('github')) return FontAwesomeIcons.github;
    if (name.contains('explorer') || name.contains('etherscan')) {
      return FontAwesomeIcons.compass;
    }
    if (name.contains('btc') || name.contains('tokenview')) {
      return FontAwesomeIcons.link;
    }
    return FontAwesomeIcons.globe;
  }

  Widget _categoryChips(List<String> categories) {
    if (categories.isEmpty) {
      return const Text('Tidak ada kategori.');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          categories.map((cat) {
            return Chip(
              label: Text(
                cat,
                style: GoogleFonts.notoSans(color: AppColors.primaryGreen),
              ),
              backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.primaryGreen),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
    );
  }
}
