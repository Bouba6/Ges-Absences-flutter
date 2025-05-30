part of 'app_pages.dart';


abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const PRESENCE_SCANNER = _Paths.PRESENCE_SCANNER;
  static const SCANNER = _Paths.SCANNER;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const PRESENCE_SCANNER = '/presence-scanner';
  static const SCANNER = '/scanner';
}
