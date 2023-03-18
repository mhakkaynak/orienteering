abstract class INavigationManager {
  Future<void> navigationToPage(String path, {Object? args});

  Future<void> navigationToPageClear(String path, {Object? args});

  void navigationToPop();
}