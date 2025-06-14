import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  final _userService = UserService();
  final _followService = FollowService();
  final authService = Get.find<AuthService>();

  final followers = <Follow>[].obs;
  final followeds = <Follow>[].obs;
  final isFollowDataLoading = false.obs;

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

  bool get canResendOtp => resendSecondsRemaining.value == 0;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // Profile
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
