import 'dart:io';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/users/PostModel.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;

class PostService {
  final _authService = Get.find<AuthService>();

  /// Fetch user posts
  Future<List<PostModel>> getUserPosts({
    required String userId,
    int page = 1,
    int perPage = 10,
    String? filterBody,
  }) async {
    try {
      final uri = UserPostConstants.index(
        userId: userId,
        page: page,
        perPage: perPage,
        bodyFilter: filterBody,
      );

      final response = await _authService.dioClient.getUri(uri);

      if (response.statusCode == 200 &&
          response.data is Map<String, dynamic> &&
          response.data['data']?['posts'] is List) {
        final List<dynamic> postsJson = response.data['data']['posts'];
        return postsJson.map((e) => PostModel.fromJson(e)).toList();
      } else {
        print("[PostService] ⚠️ Unexpected response format: ${response.data}");
        return [];
      }
    } on DioException catch (e) {
      print(
        "[PostService] ❌ DioException: ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
      );
      return [];
    } catch (e) {
      print("[PostService] ❌ Unexpected error: $e");
      return [];
    }
  }

  /// Create a new post with optional image(s)
  Future<PostModel?> createPost({
    String? title,
    required String body,
    List<File> images = const [],
  }) async {
    try {
      final formData = FormData.fromMap({
        if (title != null && title.isNotEmpty) 'title': title,
        'body': body,
        if (images.isNotEmpty)
          'images':
              images
                  .map((file) => MultipartFile.fromFileSync(file.path))
                  .toList(),
      });

      final response = await _authService.dioClient.post(
        PostConstants.createPost,
        data: formData,
      );

      if (response.statusCode == 201 &&
          response.data['data']?['post'] != null) {
        return PostModel.fromJson(response.data['data']['post']);
      } else {
        print('[PostService] ⚠️ Unexpected create response: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print(
        '[PostService] ❌ DioException: ${e.response?.statusCode} - ${e.response?.data}',
      );
      return null;
    } catch (e) {
      print('[PostService] ❌ Unexpected error: $e');
      return null;
    }
  }

  Future<bool> deletePost({required String postId}) async {
    try {
      final response = await _authService.dioClient.deleteUri(
        PostConstants.delete(postId: postId),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print(
        '[PostService] ❌ DioException while deleting post: ${e.response?.statusCode} - ${e.response?.data}',
      );
      return false;
    } catch (e) {
      print('[PostService] ❌ Unexpected error deleting post: $e');
      return false;
    }
  }

  Future<PostModel?> updatePost({
    required String postId,
    required String body,
    String? title,
    List<File> images = const [],
  }) async {
    try {
      final formData = FormData.fromMap({
        if (title != null) 'title': title,
        'body': body,
        if (images.isNotEmpty)
          'images':
              images
                  .map((file) => MultipartFile.fromFileSync(file.path))
                  .toList(),
      });

      final response = await _authService.dioClient.put(
        // GANTI dari post ➜ put
        '/posts/$postId',
        data: formData,
      );

      if (response.statusCode == 200 &&
          response.data['data'] != null &&
          response.data['data']['post'] != null) {
        return PostModel.fromJson(response.data['data']['post']);
      } else {
        print('[PostService] ⚠️ Unexpected update response: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print(
        '[PostService] ❌ DioException: ${e.response?.statusCode} - ${e.response?.data}',
      );
      return null;
    } catch (e) {
      print('[PostService] ❌ Unexpected error: $e');
      return null;
    }
  }

  /// Get detail of a single post
  Future<PostModel?> getPostById(String postId) async {
    try {
      final response = await _authService.dioClient.getUri(
        PostConstants.show(postId: postId),
      );

      if (response.statusCode == 200 &&
          response.data['data']?['post'] != null) {
        return PostModel.fromJson(response.data['data']['post']);
      } else {
        print('[PostService] ⚠️ Unexpected getPost response: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print(
        '[PostService] ❌ DioException: ${e.response?.statusCode} - ${e.response?.data}',
      );
      return null;
    } catch (e) {
      print('[PostService] ❌ Unexpected error: $e');
      return null;
    }
  }
}
