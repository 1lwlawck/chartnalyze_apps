import 'dart:io';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';
import 'package:chartnalyze_apps/app/data/models/users/UserPostStatistic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

class UserService {
  late final Dio _dio;
  final _storage = GetStorage();

  UserService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: _defaultHeaders(),
      ),
    );
  }

  Map<String, String> _defaultHeaders() {
    return {
      'Accept': 'application/json',
      'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
    };
  }

  Map<String, String> _authHeaders() {
    final token = _storage.read('token');
    if (token == null || token.isEmpty) {
      throw Exception('[UserService] Token not found.');
    }
    return {..._defaultHeaders(), 'Authorization': 'Bearer $token'};
  }

  Future<UserModel?> getSelfProfile() async {
    try {
      final response = await _dio.get(
        AuthConstants.showSelf,
        options: Options(headers: _authHeaders()),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']['user']);
      }
    } catch (e) {
      print("[getSelfProfile] Error: $e");
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _dio.get(
        '/users/$id',
        options: Options(headers: _authHeaders()),
      );

      return UserModel.fromJson(response.data['data']['user']);
    } catch (e) {
      print("[getUserById] Error: $e");
      return null;
    }
  }

  Future<bool> updateSelfProfile(Map<String, String> data) async {
    try {
      final formData = FormData.fromMap(data);

      final response = await _dio.put(
        AuthConstants.updateSelf,
        data: formData,
        options: Options(headers: _authHeaders()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("[updateSelfProfile] Error: $e");
      return false;
    }
  }

  Future<bool> updateSelfPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final formData = FormData.fromMap({
        'current_password': currentPassword.trim(),
        'password': newPassword.trim(),
        'confirm_password': confirmPassword.trim(),
      });

      final response = await _dio.patch(
        AuthConstants.updateSelfPassword,
        data: formData,
        options: Options(headers: _authHeaders()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("[updateSelfPassword] Error: $e");
      return false;
    }
  }

  Future<bool> sendOtpToEmail(String email) async {
    try {
      final response = await _dio.post(
        '/otps/send',
        data: FormData.fromMap({'email': email.trim()}),
        options: Options(headers: _authHeaders()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("[sendOtpToEmail] Error: $e");
      return false;
    }
  }

  Future<bool> updateSelfEmail({
    required String email,
    required String code,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email.trim(),
        'code': code.trim(),
      });

      final response = await _dio.patch(
        AuthConstants.updateSelfEmail,
        data: formData,
        options: Options(headers: _authHeaders()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("[updateSelfEmail] Error: $e");
      return false;
    }
  }

  Future<bool> updateSelfAvatar({required File file}) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(file.path),
      });

      final response = await _dio.patch(
        AuthConstants.updateSelfAvatar,
        data: formData,
        options: Options(headers: _authHeaders()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("[updateSelfAvatar] Error: $e");
      return false;
    }
  }

  Future<UserPostStatistic?> getUserPostStatistics(String userId) async {
    try {
      final response = await _dio.get(
        '/users/$userId/posts/statistics',
        options: Options(headers: _authHeaders()),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserPostStatistic.fromJson(response.data['data']);
      }
    } catch (e) {
      print("[getUserPostStatistics] Error: $e");
    }
    return null;
  }
}
