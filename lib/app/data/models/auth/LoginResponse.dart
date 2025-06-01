import 'package:chartnalyze_apps/app/data/models/users/UserModel.dart';

class LoginResponse {
  // Data user setelah login berhasil
  final UserModel user;

  // Token akses untuk autentikasi
  final String accessToken;

  // Pesan dari server (misalnya sukses/gagal)
  final String message;

  // Kode status dari respons server
  final int status;

  // Konstruktor
  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.message,
    required this.status,
  });

  // Konversi dari JSON ke objek LoginResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return LoginResponse(
      user:
          data['user'] != null
              ? UserModel.fromJson(data['user'])
              : UserModel.empty(),
      accessToken: data['access_token'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
    );
  }
}
