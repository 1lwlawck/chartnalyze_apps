import 'package:dio/dio.dart';
import 'package:chartnalyze_apps/app/helpers/device_info_helper.dart';

class DeviceInfoInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final deviceModel = await DeviceInfoHelper.getDeviceModel();
    final ipAddress = await DeviceInfoHelper.getIpAddress();

    options.headers.addAll({
      'User-Agent': ' $deviceModel',
      'X-Device-IP': ipAddress,
    });

    return super.onRequest(options, handler);
  }
}
