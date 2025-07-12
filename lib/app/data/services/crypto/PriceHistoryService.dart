import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:dio/dio.dart' as dio;
import 'package:chartnalyze_apps/app/data/models/crypto/PricePointModel.dart';
import 'package:get/get.dart';

class PriceHistoryService {
  final dio.Dio client = Get.find<AuthService>().dioClient;

  Future<List<PricePoint>> fetchPriceHistory(String symbol) async {
    final uri = PriceHistoryConstants.historyBySymbolUrl(symbol);

    try {
      final response = await client.get(uri.toString());

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> rawList = data['data']['price_histories'];
        return rawList.map((json) => PricePoint.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat histori harga ($symbol): ${response.statusCode}',
        );
      }
    } on dio.DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }

  /// Ambil daftar semua simbol yang tersedia
  Future<List<String>> fetchAvailableSymbols() async {
    final uri = PriceHistoryConstants.symbolsUrl();

    try {
      final response = await client.get(uri.toString());

      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> rawList = data['data']['symbols'];
        return rawList.map((e) => e.toString()).toList();
      } else {
        throw Exception('Gagal memuat simbol: ${response.statusCode}');
      }
    } on dio.DioException catch (e) {
      print('Error: ${e.response?.data ?? e.message}');
      rethrow;
    }
  }
}
