part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const FIRST_SPLASH = _Paths.FIRST_SPLASH;
  static const SECOND_SPLASH = _Paths.SECOND_SPLASH;
  static const THIRD_SPLASH = _Paths.THIRD_SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const EMAIL_VERIFICATION = _Paths.EMAIL_VERIFICATION;
  static const SUCCESS_VERIFICATION = _Paths.SUCCESS_VERIFICATION;
  static const SUCCESS_CHANGE_PASSWORD = _Paths.SUCCESS_CHANGE_PASSWORD;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const OTP_RESET_PASSWORD = _Paths.OTP_RESET_PASSWORD;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const MARKETS = _Paths.MARKETS;
  static const MARKETS_DETAIL = _Paths.MARKETS_DETAIL;
  static const NEWS = _Paths.NEWS;
  static const SEARCH = _Paths.SEARCH;
  static const COMMUNITY = _Paths.COMMUNITY;
  static const PROFILE = _Paths.PROFILE;
  static const MAIN_WRAPPER = _Paths.MAIN_WRAPPER;
  static const ONBOARDING = _Paths.ONBOARDING;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const FIRST_SPLASH = '/first-splash';
  static const SECOND_SPLASH = '/second-splash';
  static const THIRD_SPLASH = '/third-splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const EMAIL_VERIFICATION = '/email-verification';
  static const SUCCESS_VERIFICATION = '/success-verification';
  static const SUCCESS_CHANGE_PASSWORD = '/success-change-password';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP_RESET_PASSWORD = '/otp-reset-password';
  static const CHANGE_PASSWORD = '/change-password';
  static const MARKETS = '/markets';
  static const MARKETS_DETAIL = '/markets-detail';
  static const NEWS = '/news';
  static const SEARCH = '/search';
  static const COMMUNITY = '/community';
  static const PROFILE = '/profile';
  static const MAIN_WRAPPER = '/main-wrapper';
  static const ONBOARDING = '/onboarding';
}
