import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/init/firebase/firebase_auth_manager.dart';
import '../../core/init/firebase/firestore_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../model/user/user_model.dart';

class UserService {
  UserService._init() {
    _firestoreManager = FirestoreManager('user');
  }

  static UserService? _instance;

  final _errorText = 'Hata: Lütfen tekrar deneyiniz.';
  late final FirestoreManager _firestoreManager;

  static UserService get instance {
    _instance ??= UserService._init();
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
          userModel = await _firestoreManager.get<UserModel>(user.uid,
              model: userModel) as UserModel;
        } catch (e) {
          userModel = UserModel(userName, user.email, 41, user.uid, 100);
          _firestoreManager.insert(userModel, userModel.uid!);
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
}
