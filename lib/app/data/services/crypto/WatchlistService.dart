import 'dart:convert';

import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/CoinListModel.dart';
import 'package:chartnalyze_apps/app/data/models/crypto/WatchedAssetsModel.dart';
import 'package:chartnalyze_apps/app/data/services/crypto/CoinService.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WatchlistService extends GetxService {
  late final dio.Dio dioClient;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: AuthConstants.baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
        },
      ),
    );
  }

  Future<bool> addToWatchlist(CoinListModel coin) async {
    final token = _storage.read('token');
    if (token == null) {
      print("Token not found");
      return false;
    }

    try {
      final response = await dioClient.post(
        WatchlistConstants.store,
        data: dio.FormData.fromMap({
          'key': coin.id,
          'name': coin.name,
          'symbol': coin.symbol,
          'image_url': coin.icon,
        }),
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
          },
        ),
      );

      return response.statusCode == 201 || response.statusCode == 409;
    } catch (e) {
        print("addToWatchlist error: $e");
      return false;
    }
  }

  Future<bool> removeFromWatchlist(String key) async {
    final token = _storage.read('token');
    if (token == null) {
        print("Token not found");
      return false;
    }

    try {
      final response = await dioClient.delete(
        WatchlistConstants.destroy(key),
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
        print("removeFromWatchlist error: $e");
      return false;
    }
  }

  Future<List<WatchedAssetModel>> getWatchlist() async {
    final token = _storage.read('token');
    if (token == null) {
        print("Token not found");
      return [];
    }

    try {
      final response = await dioClient.get(
        WatchlistConstants.index,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data']['watched_assets'];
        return data.map((json) => WatchedAssetModel.fromJson(json)).toList();
      } else {
          print("getWatchlist failed: ${response.statusCode}");
        return [];
      }
    } catch (e) {
        print("getWatchlist error: $e");
      return [];
    }
  }

  Future<List<CoinListModel>> fetchCoinListDataByIds({
    required String ids,
  }) async {
    final url = Uri.parse(
      '${CoinGeckoConstants.baseUrl}/coins/markets'
      '?vs_currency=usd'
      '&ids=$ids'
      '&order=market_cap_desc'
      '&sparkline=true'
      '&price_change_percentage=24h,7d',
    );

    final response = await safeGet(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => CoinListModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch coin list by ids');
    }
  }
}
