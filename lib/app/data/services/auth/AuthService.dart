import 'package:chartnalyze_apps/app/data/models/auth/LoginResponse.dart';
import 'package:chartnalyze_apps/app/data/models/users/UsersActivity.dart';
import 'package:chartnalyze_apps/app/helpers/dio_interceptor.dart';
import 'package:chartnalyze_apps/app/modules/main_wrapper/controllers/main_wrapper_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chartnalyze_apps/app/constants/api.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  late final dio.Dio dioClient;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();

    dioClient = dio.Dio(
      dio.BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'x-api-key': dotenv.env['CHARTNALYZE_API_KEY'] ?? '',
        },
      ),
    );

    // Tambahkan Interceptor untuk Auth
    dioClient.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    dioClient.interceptors.add(DeviceInfoInterceptor());
  }

  /// LOGIN
  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await dioClient.post(
        AuthConstants.loginEndpoint,
        data: dio.FormData.fromMap({'identifier': email, 'password': password}),
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        final token = loginResponse.accessToken;
        await _storage.write('token', token);

        if (Get.isRegistered<MainWrapperController>()) {
          Get.delete<MainWrapperController>();
        }
        final controller = Get.put(MainWrapperController());
        controller.changeTab(0);

        print("Login successful. Token saved.");
        return true;
      }

      print("Login failed: ${response.statusCode}");
      return false;
    } on dio.DioException catch (e) {
      print("Login error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  /// REGISTER
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        AuthConstants.registerEndpoint,
        data: dio.FormData.fromMap({
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': password,
        }),
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 201) {
        print("Registration successful.");
        return true;
      }

      print("Registration failed: ${response.statusCode}");
      return false;
    } on dio.DioException catch (e) {
      print("Register error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  /// SEND OTP
  Future<bool> sendOTP(String email) async {
    try {
      final response = await dioClient.post(
        '/otps/send',
        data: dio.FormData.fromMap({'email': email}),
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        print("OTP sent to $email");
        return true;
      }

      print("Failed to send OTP: ${response.data}");
      return false;
    } on dio.DioException catch (e) {
      print("sendOTP error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  /// RESEND OTP
  Future<bool> resendOTP(String email) async {
    return await sendOTP(email);
  }

  /// VERIFY OTP
  Future<bool> verifyOTP(String email, String code) async {
    if (_storage.read('token') == null) {
      print("No token found. User not authenticated.");
      return false;
    }

    try {
      final response = await dioClient.post(
        '/users/self/email/verify',
        data: dio.FormData.fromMap({'code': code}),
        options: dio.Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        print("Email verification successful.");
        return true;
      }

      print("Verification failed: ${response.data}");
      return false;
    } on dio.DioException catch (e) {
      print("verifyOTP error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  /// FORGOT PASSWORD
  Future<bool> sendPasswordResetOTP(String email) async {
    try {
      final response = await dioClient.post(
        '/otps/send',
        data: dio.FormData.fromMap({'email': email}),
        options: dio.Options(contentType: 'multipart/form-data'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("sendPasswordResetOTP error: $e");
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await dioClient.patch(
        '/users/reset-password',
        data: dio.FormData.fromMap({
          'email': email,
          'code': code,
          'password': password,
          'confirm_password': confirmPassword,
        }),
        options: dio.Options(contentType: 'multipart/form-data'),
      );
      return response.statusCode == 200;
    } catch (e) {
      if (e is dio.DioException && e.response != null) {
        print('Server says: ${e.response?.data}');
      } else {
        print("resetPassword error: $e");
      }
      return false;
    }
  }

  /// GET USER ACTIVITIES
  Future<List<UserActivity>> getUserActivities({
    required String userId,
    int page = 1,
    int perPage = 10,
    String? typeFilter,
  }) async {
    if (_storage.read('token') == null) {
      print("No token found. User not authenticated.");
      return [];
    }

    try {
      final url = UserActivityConstants.activitiesUrl(
        userId: userId,
        page: page,
        perPage: perPage,
        type: typeFilter,
      );

      final response = await dioClient.get(url.toString());

      if (response.statusCode == 200) {
        final activities = response.data['data']['activities'] as List<dynamic>;
        return activities.map((json) => UserActivity.fromJson(json)).toList();
      }

      print("Failed to fetch activities: ${response.data}");
      return [];
    } on dio.DioException catch (e) {
      print("getUserActivities error: ${e.response?.data ?? e.message}");
      return [];
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    if (_storage.read('token') != null) {
      try {
        final response = await dioClient.delete(AuthConstants.logout);
        print("Logout API status: ${response.statusCode}");
      } catch (e) {
        print("Logout API error: $e");
      }
    }

    await _storage.remove('token');
  }
}
