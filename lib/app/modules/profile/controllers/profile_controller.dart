import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:chartnalyze_apps/app/data/services/users/FollowService.dart';
import 'package:chartnalyze_apps/app/data/services/users/UserService.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';

class ProfileController extends GetxController {
  final user = UserModel.empty().obs;
  final isLoading = true.obs;

  final _userService = UserService();

  final followers = <Follow>[].obs;
  final followeds = <Follow>[].obs;
  final isFollowDataLoading = false.obs;

  final _followService = FollowService();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    final userData = await _userService.getSelfProfile();

    if (userData != null) {
      user.value = userData;
    } else {
      print("⚠️ Failed to load user");
    }

    isLoading.value = false;
  }

  Future<void> fetchFollows(String userId) async {
    isFollowDataLoading.value = true;

    try {
      followeds.value = await _followService.getFolloweds(userId);
      followers.value = await _followService.getFollowers(userId);
      print(
        "✅ Fetched ${followeds.length} followeds and ${followers.length} followers.",
      );
    } catch (e) {
      print("❌ Error while fetching follows: $e");
    } finally {
      isFollowDataLoading.value = false;
    }
  }
}
