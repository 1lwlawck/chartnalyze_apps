import 'dart:async';
import 'dart:io';

import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UsersActivity.dart';

import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/data/services/users/FollowService.dart';
import 'package:chartnalyze_apps/app/data/services/users/UserService.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final user = UserModel.empty().obs;
  final isLoading = true.obs;

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();

  final _userService = UserService();
  final _followService = FollowService();
  final authService = Get.find<AuthService>();

  final followers = <Follow>[].obs;
  final followeds = <Follow>[].obs;
  final isFollowDataLoading = false.obs;

  final isUploadingAvatar = false.obs;

  final resendSecondsRemaining = 0.obs;
  Timer? _otpResendTimer;

  // ------------------- Tambahan untuk Activity ---------------------
  final userActivities = <UserActivity>[].obs;
  final isActivityLoading = true.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  int currentPage = 1;
  final int perPage = 10;
  String? typeFilter;

  bool get canResendOtp => resendSecondsRemaining.value == 0;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
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

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    final userData = await _userService.getSelfProfile();

    if (userData != null) {
      user.value = userData;
      nameController.text = userData.name ?? '';
      usernameController.text = userData.username;
      birthDateController.text = userData.birthDate ?? '';
      emailController.text = userData.email;

      await fetchUserActivities(userId: userData.id);
    } else {
      print("️ Failed to load user");
    }

    isLoading.value = false;
  }

  // ------------------- FETCH USER ACTIVITIES ---------------------

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
      print("Error while fetching activities: $e");
      userActivities.clear();
      hasMore.value = false;
    }

    isActivityLoading.value = false;
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
      print("Error while loading more activities: $e");
    }

    isMoreLoading.value = false;
  }

  void setTypeFilter(String? type) {
    typeFilter = type;
    if (user.value.id.isNotEmpty) {
      fetchUserActivities(userId: user.value.id);
    }
  }

  // ------------------- EXISTING PROFILE FUNCTIONALITY ---------------------

  Future<void> fetchFollows(String userId) async {
    isFollowDataLoading.value = true;

    try {
      followeds.value = await _followService.getFolloweds(userId);
      followers.value = await _followService.getFollowers(userId);
      print(
        " Fetched ${followeds.length} followeds and ${followers.length} followers.",
      );
    } catch (e) {
      print(" Error while fetching follows: $e");
    } finally {
      isFollowDataLoading.value = false;
    }
  }

  Future<bool> updateSelfProfile() async {
    final payload = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'username': usernameController.text.trim(),
      'birthDate': birthDateController.text.trim(),
    };

    if (payload.values.any((v) => v.isEmpty)) {
      Get.snackbar("Warning", "All fields must be filled");
      return false;
    }

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

  Future<bool> updateSelfPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Warning", "Please fill in all password fields");
      return false;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Mismatch", "New passwords do not match");
      return false;
    }

    try {
      final success = await _userService.updateSelfPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (success) {
        Get.snackbar("Success", "Password updated successfully");
        return true;
      } else {
        Get.snackbar("Failed", "Failed to update password");
        return false;
      }
    } catch (e) {
      print(" Exception while updating password: $e");
      Get.snackbar("Error", "Something went wrong");
      return false;
    }
  }

  Future<bool> sendOtpToEmail(String email) async {
    if (email.isEmpty || !email.contains("@")) {
      Get.snackbar("Warning", "Please enter a valid email");
      return false;
    }

    try {
      final sent = await _userService.sendOtpToEmail(email);
      if (sent) {
        Get.snackbar("Success", "OTP has been sent to $email");
        startOtpCountdown();
      } else {
        Get.snackbar("Failed", "Failed to send OTP");
      }
      return sent;
    } catch (e) {
      print(" Exception while sending OTP: $e");
      return false;
    }
  }

  Future<bool> updateSelfEmail({
    required String email,
    required String code,
  }) async {
    if (email.isEmpty || code.isEmpty) {
      Get.snackbar("Warning", "Please fill in all fields");
      return false;
    }

    try {
      final success = await _userService.updateSelfEmail(
        email: email,
        code: code,
      );
      if (success) {
        Get.snackbar("Success", "Email updated successfully");
        resetOtpCountdown();
        await fetchUserProfile();
      } else {
        Get.snackbar("Failed", "Failed to update email");
      }
      return success;
    } catch (e) {
      print(" Exception while updating email: $e");
      return false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) {
      Get.snackbar("Cancelled", "No image selected");
      return;
    }

    final File avatarFile = File(pickedImage.path);
    isUploadingAvatar.value = true;

    final success = await _userService.updateSelfAvatar(file: avatarFile);
    isUploadingAvatar.value = false;

    if (success) {
      Get.snackbar(
        "Success",
        "Avatar updated successfully",
        backgroundColor: AppColors.primaryGreen,
        colorText: Colors.white,
      );
      await fetchUserProfile();
    } else {
      Get.snackbar(
        "Failed",
        "Failed to update avatar",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

  void logout() async {
    final authService = Get.find<AuthService>();

    try {
      await authService.logout();
    } catch (e) {
      print("Logout error: $e");
    }

    // Bersihkan semua controller permanen & non-permanen
    Get.deleteAll();

    // Navigasi ke login
    Get.offAllNamed(Routes.LOGIN);

    // Snackbar konfirmasi
    Get.snackbar(
      "Logged out",
      "You have been successfully logged out",
      backgroundColor: Colors.teal,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
