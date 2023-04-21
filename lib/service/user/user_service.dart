import 'package:orienteering/core/init/firebase/firebase_auth_manager.dart';
import 'package:orienteering/model/user/user_model.dart';
import 'package:orienteering/service/location/location_service.dart';
import 'package:orienteering/service/user/base_user_service.dart';

class UserService extends BaseUserService {
  UserService._init() : super();

  static UserService? _instance;

  static UserService get instance {
    _instance ??= UserService._init();
    return _instance!;
  }

  Future<UserModel> getUser() async {
    UserModel user = UserModel.empty();

    try {
      String? uid = FirebaseAuthManager.instance.uid;
      if (uid != null) {
        user = await super.firestoreManager.get(uid, model: user) as UserModel;
        var data = await LocationService.instance // get city name
            .getCityWithLicensePlate(user.city ?? 0);
        user.cityString = data;
      }
    } catch (e) {
      // TODO error page
    }
    return user;
  }
}
