import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/constants/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Komunitas',
          style: TextStyle(
            fontFamily: AppFonts.nextTrial,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: const [
          Icon(Icons.diamond_outlined, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCommunityPost(
            username: 'Da Investopedia',
            handle: '@Dalnvestopedia',
            time: '10j',
            content:
                '"🪙 \$BTC adalah aset moneter terbaik yang pernah kita miliki" ungkap ekonom dan penulis terkenal Saifedean Ammous selama Hari Investor Bitwise Standard Corporations...',
            image:
                'https://jabarekspres.com/wp-content/uploads/2024/02/3423423-1.jpg',
            likes: 523,
            views: '186K',
            comments: 23,
            reposts: 13,
          ),
          const SizedBox(height: 12),
          _buildCommunityPost(
            username: 'Crypto Uncle',
            handle: '@CryptoUncle_Log',
            time: '8j',
            content:
                '🚨 UPDATE: AZ Sen. Wendy Rogers respond veto of her #Bitcoin ₿ \$BTC Reserve Bill, says she\'ll refile next session.',
            image: null,
            likes: 152,
            views: '98K',
            comments: 11,
            reposts: 8,
          ),
          const SizedBox(height: 12),
          _buildCommunityPost(
            username: 'Altcoin Radar',
            handle: '@AltRadar',
            time: '5j',
            content:
                '🔥 \$MANTA up 23% in the last 24h. Community getting hyped about upcoming ecosystem expansion.',
            image:
                'https://blog.pintu.co.id/wp-content/uploads/2023/09/manta-network-1024x642.jpg',
            likes: 348,
            views: '145K',
            comments: 19,
            reposts: 5,
          ),
          const SizedBox(height: 12),
          _buildCommunityPost(
            username: 'DefiVerse',
            handle: '@DefiTalks',
            time: '3j',
            content:
                '🌐 Liquid staking on Solana just hit a new ATH in TVL. \$SOL ecosystem keeps pushing boundaries. #DeFi #Solana',
            image: null,
            likes: 287,
            views: '112K',
            comments: 16,
            reposts: 4,
          ),
          const SizedBox(height: 12),
          _buildCommunityPost(
            username: 'CryptoPanicID',
            handle: '@CryptoPanicID',
            time: '1j',
            content:
                '📰 BREAKING: Binance listing rumor sparks \$TURBO price rally. Coin jumps over 40% in a few hours!',
            image:
                'https://blog.pintu.co.id/wp-content/uploads/2024/05/turbo-crypto.jpg', // contoh image dummy
            likes: 491,
            views: '200K',
            comments: 34,
            reposts: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityPost({
    required String username,
    required String handle,
    required String time,
    required String content,
    String? image,
    required int likes,
    required String views,
    required int comments,
    required int reposts,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.nextTrial,
                    ),
                    children: [
                      TextSpan(
                        text: '  $handle • $time',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          fontFamily: AppFonts.circularStd,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text('+ Mengikuti',
              //       style:
              //           TextStyle(fontSize: 12, color: AppColors.primaryGreen)),
              // )
            ],
          ),

          const SizedBox(height: 8),

          // Content
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: AppFonts.circularStd,
            ),
          ),

          if (image != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image),
            ),
          ],

          const SizedBox(height: 10),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(icon: Icons.remove_red_eye, label: views),
              _buildStat(icon: Icons.comment, label: '$comments'),
              _buildStat(icon: Icons.repeat, label: '$reposts'),
              _buildStat(icon: Icons.favorite, label: '$likes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.circularStd,
              color: Colors.grey,
            )),
      ],
    );
  }
}
