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
}
