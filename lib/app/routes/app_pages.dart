import 'package:chartnalyze_apps/app/modules/markets/views/pages/markets_detail_view.dart';
import 'package:chartnalyze_apps/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:chartnalyze_apps/app/modules/onboarding/views/onboarding_view.dart';
import 'package:get/get.dart';

import '../modules/Auth/email_verification/bindings/email_verification_binding.dart';
import '../modules/Auth/email_verification/views/email_verification_view.dart';
import '../modules/Auth/email_verification/views/email_verification_success_view.dart';
import '../modules/Auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/Auth/forgot_password/views/pages/change_password_view.dart';
import '../modules/Auth/forgot_password/views/pages/forgot_password_view.dart';
import '../modules/Auth/forgot_password/views/pages/verify_otp_view.dart';
import '../modules/Auth/login/bindings/login_binding.dart';
import '../modules/Auth/login/views/pages/login_view.dart';
import '../modules/Auth/register/bindings/register_binding.dart';
import '../modules/Auth/register/views/pages/register_view.dart';
import '../modules/intro/first_splash/bindings/first_splash_binding.dart';
import '../modules/intro/first_splash/views/first_splash_view.dart';
import '../modules/intro/second_splash/bindings/second_splash_binding.dart';
import '../modules/intro/second_splash/views/second_splash_view.dart';
import '../modules/intro/third_splash/bindings/third_splash_binding.dart';
import '../modules/intro/third_splash/views/third_splash_view.dart';
import '../modules/community/bindings/community_binding.dart';
import '../modules/community/views/community_view.dart';
import '../modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../modules/main_wrapper/views/main_wrapper_view.dart';
import '../modules/markets/bindings/markets_binding.dart';
import '../modules/markets/views/pages/markets_view.dart';
import '../modules/news/bindings/news_binding.dart';
import '../modules/news/views/pages/news_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/pages/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
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
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.OTP_RESET_PASSWORD,
      page: () => ResetPasswordOtpView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.MARKETS,
      page: () => MarketsView(),
      binding: MarketsBinding(),
    ),
    GetPage(
      name: _Paths.MARKETS_DETAIL,
      page: () => MarketDetailView(),
      binding: MarketsBinding(),
    ),
    GetPage(name: _Paths.NEWS, page: () => NewsView(), binding: NewsBinding()),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.COMMUNITY,
      page: () => CommunityView(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_WRAPPER,
      page: () => MainWrapperView(),
      binding: MainWrapperBinding(),
    ),
  ];
}
