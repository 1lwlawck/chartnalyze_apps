import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  final storage = GetStorage();

  final token = storage.read('token');
  final onboardingDone = storage.read('onboarding_done') ?? false;

  final initialRoute =
      token != null && token.isNotEmpty
          ? Routes.SPLASH_REDIRECT
          : (onboardingDone ? Routes.LOGIN : Routes.ONBOARDING);

  Get.put<AuthService>(AuthService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Chartnalyze Apps",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryGreen,
          secondary: Colors.white,
        ),
      ),
    ),
  );
}
