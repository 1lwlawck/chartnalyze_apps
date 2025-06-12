import 'package:device_info_plus/device_info_plus.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'dart:io';

class DeviceInfoHelper {
  static Future<String> getDeviceModel() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return '${androidInfo.manufacturer} ${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    } else {
      return 'Unknown Device';
    }
  }

  static Future<String> getIpAddress() async {
    try {
      final ip = await Ipify.ipv4();
      return ip;
    } catch (e) {
      print("Failed to get IP: $e");
      return '0.0.0.0';
    }
  }
}
