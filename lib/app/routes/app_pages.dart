import 'package:get/get.dart';

import '../modules/first_splash/bindings/first_splash_binding.dart';
import '../modules/first_splash/views/first_splash_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/second_splash/bindings/second_splash_binding.dart';
import '../modules/second_splash/views/second_splash_view.dart';
import '../modules/third_splash/bindings/third_splash_binding.dart';
import '../modules/third_splash/views/third_splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.FIRST_SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FIRST_SPLASH,
      page: () => FirstSplashView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      binding: FirstSplashBinding(),
    ),
    GetPage(
      name: _Paths.SECOND_SPLASH,
      page: () => SecondSplashView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      binding: SecondSplashBinding(),
    ),
    GetPage(
      name: _Paths.THIRD_SPLASH,
      page: () => ThirdSplashView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 500),
      binding: ThirdSplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
