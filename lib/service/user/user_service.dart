import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/init/firebase/firebase_auth_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';

class UserService {
  UserService._init();

  static UserService? _instance;

  static UserService get instance {
    _instance ??= UserService._init();
    return _instance!;
  }

  Future<String?> signInWithGoogle() async {
    try {
      var user = await FirebaseAuthManager.instance.signInWithGoogle();
    } catch (e) {
      return e.toString();
    } 
    NavigationManager.instance.navigationToPageClear(NavigationConstant.home);
    return null;
  }
}
