import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chartnalyze_apps/app/constants/api.dart';

class CommunityService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AuthConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
      },
    ),
  );

  final GetStorage _storage = GetStorage();

  /// Get all posts with pagination
  Future<List<PostModel>> getPosts({int page = 1}) async {
    final token = _storage.read('token');
    if (token == null || token.isEmpty) {
      throw Exception('🔒 Token not found. User not authenticated.');
    }

    try {
      final response = await _dio.get(
        '/posts?per_page=10&page=$page',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // ✅ Kirim token
          },
        ),
      );

      final data = response.data['data']['posts'] as List;
      return data.map((e) => PostModel.fromJson(e)).toList();
    } on DioException catch (e) {
      print('❌ Failed to fetch posts: ${e.response?.statusCode}');
      print('❌ Error message: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}
