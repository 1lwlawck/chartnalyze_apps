import 'dart:ui';

import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:chartnalyze_apps/app/data/services/users/CommunityService.dart';
import 'package:chartnalyze_apps/app/data/services/users/UserService.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final CommunityService _communityService = CommunityService();
  final UserService _userService = UserService();

  var posts = <PostModel>[].obs;
  var usersMap = <String, UserModel>{}.obs;
  var isLoading = true.obs;
  var isUserLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPostsWithUser();
  }

  Future<void> fetchPostsWithUser() async {
    try {
      isLoading.value = true;
      isUserLoading.value = true;

      final fetchedPosts = await _communityService.getPosts();
      posts.assignAll(fetchedPosts);

      final uniqueUserIds = fetchedPosts.map((p) => p.userId).toSet();

      // Optimasi: fetch user secara paralel
      await Future.wait(
        uniqueUserIds.map((id) async {
          if (!usersMap.containsKey(id)) {
            final user = await _userService.getUserById(id);
            if (user != null) {
              usersMap[id] = user;
            }
          }
        }),
      );

      isUserLoading.value = false;
    } catch (e) {
      print("[CommunityController] Failed to fetch posts/users: $e");
      _showSnackbar("Error", "Failed to load community data", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  UserModel? getUser(String userId) {
    return usersMap[userId];
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFE57373) : null,
      colorText: isError ? const Color(0xFFFFFFFF) : null,
    );
  }
}
