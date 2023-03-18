import 'package:flutter/widgets.dart';

import 'base_navigation_manager.dart';

class NavigationManager implements INavigationManager {
  NavigationManager._init() {
    navigationKey = GlobalKey();
  }

  late final GlobalKey<NavigatorState> navigationKey;

  static NavigationManager? _instance;

  @override
  Future<void> navigationToPage(String path, {Object? args}) async {
    // To go to another page
    await navigationKey.currentState
        ?.pushNamed(path, arguments: args);
  }

  @override
  Future<void> navigationToPageClear(String path, {Object? args}) async {
    // To go to another page and remove the previous page
    await navigationKey.currentState
        ?.pushNamedAndRemoveUntil(path, _removeOldPage, arguments: args);
  }

  @override
  void navigationToPop() {
    // To go to previous page 
    navigationKey.currentState?.pop();
  }

  static NavigationManager? get instance {
    _instance ??= NavigationManager._init();
    return _instance;
  }

  get _removeOldPage => (Route<dynamic> route) => false;
}