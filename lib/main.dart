import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:chartnalyze_apps/app/services/auth/AuthService.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<AuthService>(AuthService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Chartnalyze Apps",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
