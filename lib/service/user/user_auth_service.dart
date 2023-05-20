import 'package:firebase_auth/firebase_auth.dart';
import 'package:orienteering/service/user/base_user_service.dart';

import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/init/firebase/firebase_auth_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../model/user/user_model.dart';

class UserAuthService extends BaseUserService {
  UserAuthService._init() : super();

  static UserAuthService? _instance;

  final _errorText = 'Hata: Lütfen tekrar deneyiniz.';

  static UserAuthService get instance {
    _instance ??= UserAuthService._init();
    return _instance!;
  }

  Future<String?> signInWithGoogle() async {
    String userName = '';
    try {
      User? user = await FirebaseAuthManager.instance.signInWithGoogle();
      if (user != null) {
        userName = (user.displayName ?? user.email) ?? '';
        UserModel userModel = UserModel.empty();
        try {
          userModel = await super
              .firestoreManager
              .get<UserModel>(user.uid, model: userModel) as UserModel;
        } catch (e) {
          userModel = UserModel(userName, user.email, 41, user.uid, 100, 1, '');
          super.firestoreManager.insert(userModel, userModel.uid!);
        }
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.home);
      }
    } catch (e) {
      return _errorText;
    }
    return null;
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuthManager.instance.signInWithEmail(email, password);
      NavigationManager.instance.navigationToPageClear(NavigationConstant.home);
    } catch (e) {
      return _errorText;
    }
    return null;
  }

  Future<String?> registerWithEmail(UserModel user) async {
    try {
      var userData = await super
          .firestoreManager
          .getByName('userName', user.userName.toString());
      if (userData != '') {
        throw Exception(
            'Bu kullanıcı adı daha önce kullanılmış. Lütfen başka bir kullanıcı adı deneyiniz');
      }
      await FirebaseAuthManager.instance
          .registerWithEmail(user.email.toString(), user.password.toString());
      user.uid = FirebaseAuthManager.instance.uid.toString();
      user.coin = 100;
      user.level = 1.0;
      user.city = 41;
      user.gender = '';
      await super.firestoreManager.insert(user, user.uid.toString());
      NavigationManager.instance.navigationToPageClear(NavigationConstant.home);
    } catch (e) {
      return _errorText;
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    NavigationManager.instance.navigationToPageClear(NavigationConstant.auth);
  }
}
