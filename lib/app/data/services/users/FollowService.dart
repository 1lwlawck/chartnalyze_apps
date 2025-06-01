import 'package:chartnalyze_apps/app/data/models/users/FollowModel.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chartnalyze_apps/app/constants/api.dart';

class FollowService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: AuthConstants.baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  );
  final _storage = GetStorage();

  Future<List<Follow>> getFolloweds(String userId) async {
    final token = _storage.read('token');
    final response = await _dio.get(
      '/users/$userId/followeds?join=followed',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data']['follows'] as List;
    return data.map((e) => Follow.fromJson(e)).toList();
  }

  Future<List<Follow>> getFollowers(String userId) async {
    final token = _storage.read('token');
    final response = await _dio.get(
      '/users/$userId/follows?join=follower&sort=follower.name',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data']['follows'] as List;
    return data.map((e) => Follow.fromJson(e)).toList();
  }
}
