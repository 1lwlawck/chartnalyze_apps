import 'package:chartnalyze_apps/app/modules/profile/controllers/profile_controller.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/myAccount/user_activity_card.dart';
import 'package:chartnalyze_apps/app/modules/profile/views/widgets/myAccount/user_statistic_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserActivityView extends StatelessWidget {
  const UserActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160.7,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg-appbar.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "User Activity",
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "See what actions you've taken recently.",
                          style: GoogleFonts.newsreader(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        indicatorColor: Colors.white,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: 'Authentication'),
                          Tab(text: 'Statistics'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Tab Content Area
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Authentication Activity
                  Obx(() {
                    if (controller.isActivityLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.userActivities.isEmpty) {
                      return const Center(
                        child: Text("No authentication logs found"),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.userActivities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final activity = controller.userActivities[index];
                        return UserActivityCard(activity: activity);
                      },
                    );
                  }),

                  // Tab 2: User Statistics (wrapped for layout control)
                  Obx(() {
                    if (controller.isStatisticLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final stat = controller.postStatistic.value;
                    if (stat == null) {
                      return const Center(
                        child: Text("No statistics available."),
                      );
                    }

                    return UserStatisticsChart(
                      data: {
                        "Posts": stat.postCount,
                        "Comments": stat.commentCount,
                        "Likes": stat.likeCount,
                        "Saves": stat.saveCount,
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
