import 'package:chartnalyze_apps/app/modules/email_verification/views/success_verification_email.dart';
import 'package:get/get.dart';

import '../modules/email_verification/bindings/email_verification_binding.dart';
import '../modules/email_verification/views/email_verification_view.dart';
import '../modules/onboarding/first_splash/bindings/first_splash_binding.dart';
import '../modules/onboarding/first_splash/views/first_splash_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/onboarding/second_splash/bindings/second_splash_binding.dart';
import '../modules/onboarding/second_splash/views/second_splash_view.dart';
import '../modules/onboarding/third_splash/bindings/third_splash_binding.dart';
import '../modules/onboarding/third_splash/views/third_splash_view.dart';

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
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.EMAIL_VERIFICATION,
      page: () => EmailVerificationView(),
      binding: EmailVerificationBinding(),
    ),
    GetPage(
      name: _Paths.SUCCESS_VERIFICATION,
      page: () => SuccessVerificationView(),
      binding: EmailVerificationBinding(),
    )
  ];
}
