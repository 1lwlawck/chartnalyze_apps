import 'dart:io';

import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class UserService {
  final dioClient = Dio(
    BaseOptions(
      baseUrl: AuthConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
        'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
      },
    ),
  );

  final _storage = GetStorage();

  ///  Get profile of currently logged-in user
  Future<UserModel?> getSelfProfile() async {
    final token = _storage.read('token');
    if (token == null) {
      return null;
    }

    try {
      final response = await dioClient.get(
        AuthConstants.showSelf,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']['user']);
      }
    } catch (e) {
    }

    return null;
  }

  ///  Get user by ID (for community posts, etc.)
  Future<UserModel?> getUserById(String id) async {
    final token = _storage.read('token');
    if (token == null) {
      return null;
    }

    try {
      final response = await dioClient.get(
        '/users/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
            'Accept': 'application/json',
          },
        ),
      );

      return UserModel.fromJson(response.data['data']['user']);
    } catch (e) {
      return null;
    }
  }

  ///  Update user profile
  Future<bool> updateSelfProfile(Map<String, String> data) async {
    final token = _storage.read('token');
    if (token == null) {
      return false;
    }

    try {
      final formData = FormData.fromMap(data);

      final response = await dioClient.put(
        AuthConstants.updateSelf,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
        " [updateSelfProfile] Error: ${e is DioException ? e.response?.data : e}",
      );
      return false;
    }
  }

  ///  Update user password
  Future<bool> updateSelfPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final token = _storage.read('token');
    if (token == null) {
      return false;
    }

    try {
      final formData = FormData.fromMap({
        'current_password': currentPassword.trim(),
        'password': newPassword.trim(),
        'confirm_password': confirmPassword.trim(),
      });

      final response = await dioClient.patch(
        AuthConstants.updateSelfPassword,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  ///  Kirim OTP ke email baru
  Future<bool> sendOtpToEmail(String email) async {
    final token = _storage.read('token');
    if (token == null) {
      return false;
    }

    try {

      final response = await dioClient.post(
        '/otps/send',
        data: FormData.fromMap({'email': email.trim()}),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

        " [sendOtpToEmail] Response: ${response.statusCode} - ${response.data}",
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      return false;
    }
  }

  ///  Update email dengan OTP
  Future<bool> updateSelfEmail({
    required String email,
    required String code,
  }) async {
    final token = _storage.read('token');
    if (token == null) {
      return false;
    }

    try {
      final formData = FormData.fromMap({
        'email': email.trim(),
        'code': code.trim(),
      });


      final response = await dioClient.patch(
        AuthConstants.updateSelfEmail,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );


      return response.statusCode == 200;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateSelfAvatar({required File file}) async {
    final token = _storage.read('token');
    if (token == null) return false;

    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(file.path),
      });

      final response = await dioClient.patch(
        AuthConstants.updateSelfAvatar,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      return false;
    } catch (e) {
      return false;
    }
  }
}
