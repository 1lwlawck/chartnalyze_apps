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
      for (var id in uniqueUserIds) {
        if (!usersMap.containsKey(id)) {
          final user = await _userService.getUserById(id);
          usersMap[id] = user!;
        }
      }

      isUserLoading.value = false;
    } catch (e) {
      print("Failed to fetch posts/users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  UserModel? getUser(String userId) {
    return usersMap[userId];
  }
}
