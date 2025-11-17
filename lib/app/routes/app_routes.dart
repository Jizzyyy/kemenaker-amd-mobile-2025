part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const ADD_TRANSACTION = _Paths.ADD_TRANSACTION;
  static const TRANSACTION_DETAIL = _Paths.TRANSACTION_DETAIL;
  static const EDIT_TRANSACTION = _Paths.EDIT_TRANSACTION;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const ADD_TRANSACTION = '/add-transaction';
  static const TRANSACTION_DETAIL = '/transaction-detail';
  static const EDIT_TRANSACTION = '/edit-transaction';
}
