import 'package:flutter/material.dart';
import 'package:orienteering/pages/auth/auth_page.dart';
import 'package:orienteering/pages/error/error_page.dart';
import 'package:orienteering/pages/home/home_page.dart';
import 'package:orienteering/pages/home/subpages/search_subpage.dart';
import 'package:orienteering/pages/user/user_edit_page.dart';

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
      case NavigationConstant.auth:
        return _navigationToDefault(const AuthPage(), args);
      case NavigationConstant.error:
        return _navigationToDefault(const ErrorPage(), args);
      case NavigationConstant.login:
        return _navigationToDefault(LoginPage(), args);
      case NavigationConstant.register:
        return _navigationToDefault(RegisterPage(), args);
      case NavigationConstant.home:
        return _navigationToDefault(const HomePage(), args);
      case NavigationConstant.userEdit:
        return _navigationToDefault(const UserEditPage(), args);
        case NavigationConstant.search:
        return _navigationToDefault(const SearchSubPage(), args);
      default:
        return _navigationToDefault(const ErrorPage(), args);
    }
  }

  MaterialPageRoute _navigationToDefault(Widget page, RouteSettings args) =>
      MaterialPageRoute(builder: (context) => page, settings: args);
}
