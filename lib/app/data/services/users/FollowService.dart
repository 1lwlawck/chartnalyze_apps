import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FollowService {
  late final Dio _dio;
  final _storage = GetStorage();

  FollowService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        headers: _defaultHeaders(),
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// Default headers (tanpa token)
  Map<String, String> _defaultHeaders() {
    return {
      'Accept': 'application/json',
      'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
    };
  }

  /// Headers dengan token authorization
  Map<String, String> _authHeaders() {
    final token = _storage.read('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found. User not authenticated.');
    }
    return {..._defaultHeaders(), 'Authorization': 'Bearer $token'};
  }

  Future<List<Follow>> getFolloweds(String userId) async {
    try {
      final response = await _dio.get(
        '/users/$userId/followeds?join=followed',
        options: Options(headers: _authHeaders()),
      );

      final data = response.data['data']['follows'] as List;
      return data.map((e) => Follow.fromJson(e)).toList();
    } on DioException catch (e) {
      print('Failed to get followeds: ${e.message}');
      rethrow;
    }
  }

  Future<List<Follow>> getFollowers(String userId) async {
    try {
      final response = await _dio.get(
        '/users/$userId/follows?join=follower&sort=follower.name',
        options: Options(headers: _authHeaders()),
      );

      final data = response.data['data']['follows'] as List;
      return data.map((e) => Follow.fromJson(e)).toList();
    } on DioException catch (e) {
      print('Failed to get followers: ${e.message}');
      rethrow;
    }
  }
}
