import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  Future<bool> login({required String email, required String password}) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (email == "admin@test.com" && password == "123456") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Simulasi API call
      await Future.delayed(const Duration(seconds: 2));

      if (username == "already_taken") {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Simulasi API call
      await Future.delayed(const Duration(seconds: 2));

      print('Sending reset email to $email');
      return true;
    } catch (e) {
      Get.snackbar(
        'Failed',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
