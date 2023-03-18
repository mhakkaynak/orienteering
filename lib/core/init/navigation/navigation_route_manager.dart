import 'package:flutter/material.dart';

import '../../../pages/auth/login_page.dart';
import '../../../pages/auth/register_page.dart';
import '../../constants/navigation/navigation_constant.dart';


class NavigationRouteManager {
  NavigationRouteManager._init();

  static NavigationRouteManager? _instance;

  static NavigationRouteManager? get instance {
    _instance ??= NavigationRouteManager._init();
    return _instance;
  }

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstant.login:
        return _navigationToDefault(const LoginPage(), args);
      case NavigationConstant.register:
        return _navigationToDefault(const RegisterPage(), args);
      default:
        return _navigationToDefault(const LoginPage(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) =>
      MaterialPageRoute(builder: (context) => page, settings: args);
}