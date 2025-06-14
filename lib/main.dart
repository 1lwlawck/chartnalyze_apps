import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chartnalyze_apps/app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chartnalyze_apps/app/data/services/auth/AuthService.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();

  runApp(const ChartnalyzeApp());
}

Future<void> _initServices() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");

  // Global Dependency Injection
  Get.put<AuthService>(AuthService(), permanent: true);
}

class ChartnalyzeApp extends StatelessWidget {
  const ChartnalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final token = storage.read('token');
    final onboardingDone = storage.read('onboarding_done') ?? false;

    final initialRoute =
        token != null && token.isNotEmpty
            ? Routes.SPLASH_REDIRECT
            : (onboardingDone ? Routes.LOGIN : Routes.ONBOARDING);

    return GetMaterialApp(
      title: "Chartnalyze Apps",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: _buildAppTheme(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.primaryGreen,
        secondary: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
