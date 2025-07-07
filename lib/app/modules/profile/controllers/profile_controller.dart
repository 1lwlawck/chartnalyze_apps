import 'dart:async';
import 'dart:io';
import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserPostStatistic.dart';
import 'package:chartnalyze_apps/app/data/services/users/PostService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UsersActivity.dart';
import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/data/services/users/FollowService.dart';
import 'package:chartnalyze_apps/app/data/services/users/UserService.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final user = UserModel.empty().obs;
  final isLoading = true.obs;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final isSubmittingPost = false.obs;
  final editingPostId = RxnString();

  final _userService = UserService();
  final _followService = FollowService();
  final _postService = PostService();
  final authService = Get.find<AuthService>();

  final followers = <Follow>[].obs;
  final followeds = <Follow>[].obs;
  final isFollowDataLoading = false.obs;
  final postStatistic = Rxn<UserPostStatistic>();
  final isStatisticLoading = false.obs;

  final isUploadingAvatar = false.obs;

  final resendSecondsRemaining = 0.obs;
  Timer? _otpResendTimer;

  final userActivities = <UserActivity>[].obs;
  final isActivityLoading = true.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  int currentPage = 1;
  final int perPage = 10;
  String? typeFilter;

  final userPosts = <PostModel>[].obs;
  final isPostLoading = false.obs;

  bool get canResendOtp => resendSecondsRemaining.value == 0;

  final formKey = GlobalKey<FormState>();
  final selectedImages = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserPosts() async {
    if (user.value.id.isEmpty) return;
    isPostLoading.value = true;
    try {
      final result = await _postService.getUserPosts(userId: user.value.id);
      userPosts.assignAll(result);
    } catch (e) {
      print("Error fetching user posts: $e");
    } finally {
      isPostLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 80);

    if (pickedFiles.isNotEmpty) {
      selectedImages.addAll(pickedFiles.map((x) => File(x.path)));
    }
  }

  void removeImage(File file) {
    selectedImages.remove(file);
  }

  Future<void> createPost() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (body.isEmpty) {
      Get.snackbar("Validation", "Post body cannot be empty");
      return;
    }

    isSubmittingPost.value = true;
    try {
      final result = await _postService.createPost(
        title: title.isNotEmpty ? title : null,
        body: body,
        images: selectedImages,
      );

      if (result != null) {
        titleController.clear();
        bodyController.clear();
        selectedImages.clear();
        editingPostId.value = null;
        await fetchUserPosts();
        Get.back();
        Get.snackbar("Success", "Post created successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to create post");
    } finally {
      isSubmittingPost.value = false;
    }
  }

  Future<void> deletePost(String postId) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Text(
          'Delete Post',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this post?',
          style: GoogleFonts.aBeeZee(fontSize: 14, color: Colors.black54),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
              textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await _postService.deletePost(postId: postId);
      if (success) {
        Get.snackbar(
          'Deleted',
          'Post deleted successfully',
          backgroundColor: Colors.green[600],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
        await fetchUserPosts();
      } else {
        Get.snackbar(
          'Failed',
          'Failed to delete post',
          backgroundColor: Colors.red[400],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      print('[ProfileController] ❌ Error deleting post: $e');
    }
  }

  Future<void> updatePost({
    required String postId,
    required String body,
    String? title,
    List<File> images = const [],
  }) async {
    isSubmittingPost.value = true;

    try {
      final result = await _postService.updatePost(
        postId: postId,
        title: title,
        body: body,
        images: images,
      );

      if (result != null) {
        Get.back(); // Close form
        editingPostId.value = null; // reset mode
        await fetchUserPosts(); // Refresh list
        Get.snackbar("Success", "Post updated successfully");
      } else {
        Get.snackbar("Error", "Failed to update post");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmittingPost.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final userData = await _userService.getSelfProfile();
      if (userData != null) {
        user.value = userData;
        nameController.text = userData.name ?? '';
        usernameController.text = userData.username;
        birthDateController.text = userData.birthDate ?? '';
        emailController.text = userData.email;

        await fetchUserActivities(userId: userData.id);
        await fetchUserPostStatistics(userId: userData.id);
        await fetchUserPosts();
      } else {
        _showSnackbar("Error", "Failed to load user", isError: true);
      }
    } catch (e) {
      print("Error fetching user: $e");
      _showSnackbar("Error", "Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSelfProfile() async {
    final payload = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'username': usernameController.text.trim(),
      'birth_date': birthDateController.text.trim(),
    };

    // Cek field kosong
    if (payload.values.any((v) => v.isEmpty)) {
      Get.snackbar("Warning", "All fields must be filled");
      return false;
    }

    // Log sebelum kirim
    print(" Sending update payload: $payload");

    try {
      final success = await _userService.updateSelfProfile(payload);
      if (success) {
        await fetchUserProfile();
        return true;
      }
      return false;
    } catch (e) {
      print(" Update failed: $e");
      return false;
    }
  }

  // Password
  Future<bool> updateSelfPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackbar("Warning", "All fields must be filled", isError: true);
      return false;
    }

    if (newPassword != confirmPassword) {
      _showSnackbar("Mismatch", "New passwords do not match", isError: true);
      return false;
    }

    try {
      final success = await _userService.updateSelfPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (success) {
        _showSnackbar("Success", "Password updated");
        return true;
      } else {
        _showSnackbar("Failed", "Failed to update password", isError: true);
        return false;
      }
    } catch (e) {
      print("Error updating password: $e");
      _showSnackbar("Error", "Something went wrong", isError: true);
      return false;
    }
  }

  // Email Update + OTP
  Future<bool> sendOtpToEmail(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      _showSnackbar("Warning", "Please enter a valid email", isError: true);
      return false;
    }

    try {
      final sent = await _userService.sendOtpToEmail(email);
      if (sent) {
        _showSnackbar("Success", "OTP sent to $email");
        startOtpCountdown();
      } else {
        _showSnackbar("Failed", "Failed to send OTP", isError: true);
      }
      return sent;
    } catch (e) {
      print("Error sending OTP: $e");
      _showSnackbar("Error", "Something went wrong", isError: true);
      return false;
    }
  }

  Future<bool> updateSelfEmail({
    required String email,
    required String code,
  }) async {
    if (email.isEmpty || code.isEmpty) {
      _showSnackbar("Warning", "Please fill in all fields", isError: true);
      return false;
    }

    try {
      final success = await _userService.updateSelfEmail(
        email: email,
        code: code,
      );
      if (success) {
        _showSnackbar("Success", "Email updated");
        resetOtpCountdown();
        await fetchUserProfile();
      } else {
        _showSnackbar("Failed", "Failed to update email", isError: true);
      }
      return success;
    } catch (e) {
      print("Error updating email: $e");
      _showSnackbar("Error", "Something went wrong", isError: true);
      return false;
    }
  }

  void startOtpCountdown() {
    resendSecondsRemaining.value = 60;
    _otpResendTimer?.cancel();
    _otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsRemaining.value == 0) {
        timer.cancel();
      } else {
        resendSecondsRemaining.value--;
      }
    });
  }

  void resetOtpCountdown() {
    _otpResendTimer?.cancel();
    resendSecondsRemaining.value = 0;
  }

  // Avatar Upload
  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage == null) {
      _showSnackbar("Cancelled", "No image selected", isError: true);
      return;
    }

    isUploadingAvatar.value = true;
    final success = await _userService.updateSelfAvatar(
      file: File(pickedImage.path),
    );
    isUploadingAvatar.value = false;

    if (success) {
      _showSnackbar("Success", "Avatar updated", isError: false);
      await fetchUserProfile();
    } else {
      _showSnackbar("Failed", "Failed to update avatar", isError: true);
    }
  }

  // Followers / Followeds
  Future<void> fetchFollows(String userId) async {
    isFollowDataLoading.value = true;
    try {
      followeds.value = await _followService.getFolloweds(userId);
      followers.value = await _followService.getFollowers(userId);
    } catch (e) {
      print("Error fetching follows: $e");
      _showSnackbar("Error", "Failed to load follows", isError: true);
    } finally {
      isFollowDataLoading.value = false;
    }
  }

  // Activities
  Future<void> fetchUserActivities({required String userId}) async {
    isActivityLoading.value = true;
    currentPage = 1;
    try {
      final result = await authService.getUserActivities(
        userId: userId,
        page: currentPage,
        perPage: perPage,
        typeFilter: typeFilter,
      );

      userActivities.assignAll(result);
      hasMore.value = result.length == perPage;
    } catch (e) {
      print("Error fetching activities: $e");
      _showSnackbar("Error", "Failed to load activities", isError: true);
    } finally {
      isActivityLoading.value = false;
    }
  }

  Future<void> loadMoreActivities({required String userId}) async {
    if (!hasMore.value || isMoreLoading.value) return;

    isMoreLoading.value = true;
    currentPage++;

    try {
      final result = await authService.getUserActivities(
        userId: userId,
        page: currentPage,
        perPage: perPage,
        typeFilter: typeFilter,
      );

      userActivities.addAll(result);
      hasMore.value = result.length == perPage;
    } catch (e) {
      print("Error loading more activities: $e");
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> fetchUserPostStatistics({required String userId}) async {
    isStatisticLoading.value = true;
    try {
      final result = await _userService.getUserPostStatistics(userId);
      if (result != null) {
        postStatistic.value = result;
      } else {
        _showSnackbar("Failed", "No statistics found", isError: true);
      }
    } catch (e) {
      print("Error fetching post statistics: $e");
      _showSnackbar("Error", "Something went wrong", isError: true);
    } finally {
      isStatisticLoading.value = false;
    }
  }

  void submitPost() {
    if (!formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final images = selectedImages;

    if (editingPostId.value != null) {
      updatePost(
        postId: editingPostId.value!,
        title: title,
        body: body,
        images: images,
      ).then((_) => editingPostId.value = null); // reset mode
    } else {
      createPost();
    }
  }

  void setTypeFilter(String? type) {
    typeFilter = type;
    if (user.value.id.isNotEmpty) {
      fetchUserActivities(userId: user.value.id);
    }
  }

  // Logout
  void logout() async {
    try {
      await authService.logout();
      Get.deleteAll(force: true);
      Get.put<AuthService>(AuthService(), permanent: true);
      Get.offAllNamed(Routes.LOGIN);
      _showSnackbar("Logged out", "You have been logged out");
    } catch (e) {
      _showSnackbar("Logout Failed", "Something went wrong", isError: true);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    birthDateController.dispose();
    emailController.dispose();
    _otpResendTimer?.cancel();
    super.onClose();
  }

  void _showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor:
          isError ? const Color(0xFFE57373) : AppColors.primaryGreen,
      colorText: Colors.white,
    );
  }
}
