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

  /// ✅ Get profile of currently logged-in user
  Future<UserModel?> getSelfProfile() async {
    final token = _storage.read('token');
    if (token == null) return null;

    try {
      final response = await dioClient.get(
        AuthConstants.showSelf,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return UserModel.fromJson(response.data['data']['user']);
      }
    } catch (e) {
      print("❌ getSelfProfile error: $e");
    }

    return null;
  }

  /// ✅ Get user by ID (for community posts, etc.)
  Future<UserModel> getUserById(String id) async {
    final token = _storage.read('token');

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
  }
}
