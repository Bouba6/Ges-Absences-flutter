part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SCANNER = _Paths.SCANNER;
  static const MAIN = _Paths.MAIN;
  static const POINTAGE = _Paths.POINTAGE;
  static const ABSCENCE = _Paths.ABSCENCE;
  static const LOGIN = _Paths.LOGIN;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SCANNER = '/scanner';
  static const MAIN = '/main';
  static const POINTAGE = '/pointage';
  static const ABSCENCE = '/abscence';
  static const LOGIN = '/login';
}
