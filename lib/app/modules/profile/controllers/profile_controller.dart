import 'dart:async';
import 'dart:io';

import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:chartnalyze_apps/app/data/services/users/FollowService.dart';
import 'package:chartnalyze_apps/app/data/services/users/UserService.dart';
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

  final followers = <Follow>[].obs;
  final followeds = <Follow>[].obs;
  final isFollowDataLoading = false.obs;

  final isUploadingAvatar = false.obs;

  final resendSecondsRemaining = 0.obs;
  Timer? _otpResendTimer;

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
    } else {
    }

    isLoading.value = false;
  }

  Future<void> fetchFollows(String userId) async {
    isFollowDataLoading.value = true;

    try {
      followeds.value = await _followService.getFolloweds(userId);
      followers.value = await _followService.getFollowers(userId);
        " Fetched \${followeds.length} followeds and \${followers.length} followers.",
      );
    } catch (e) {
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

    // Cek field kosong
    if (payload.values.any((v) => v.isEmpty)) {
      Get.snackbar("Warning", "All fields must be filled");
      return false;
    }

    // Log sebelum kirim

    try {
      final success = await _userService.updateSelfProfile(payload);
      if (success) {
        await fetchUserProfile(); // refresh
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSelfPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validasi form kosong
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
        startOtpCountdown(); // Start countdown for resend
      } else {
        Get.snackbar("Failed", "Failed to send OTP");
      }
      return sent;
    } catch (e) {
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
        resetOtpCountdown(); // Reset countdown after success
        await fetchUserProfile(); // refresh UI
      } else {
        Get.snackbar("Failed", "Failed to update email");
      }
      return success;
    } catch (e) {
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

      await fetchUserProfile(); // Refresh data user
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
    _otpResendTimer?.cancel(); // Tambahkan ini
    super.onClose();
  }

  void logout() async {
    final authService = Get.find<AuthService>();
    await authService.logout();

    Get.offAllNamed('/login'); // Arahkan ke halaman login
    Get.snackbar("Logged out", "You have been successfully logged out");
  }
}
