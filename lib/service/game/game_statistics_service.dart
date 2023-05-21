import 'package:orienteering/service/user/user_service.dart';

import '../../core/init/firebase/firestore_manager.dart';
import '../../model/game/game_statistics_model.dart';
import '../../model/user/user_model.dart';

class GameStatisticsService {
  GameStatisticsService(collectionName) {
    _firestoreManager = FirestoreManager(collectionName);
  }

  late final FirestoreManager _firestoreManager;

  Future<void> insert(String uid, List<String> qrList) async {
    try {
      Map<String, String> totalMark = {};
      for (var item in qrList) {
        totalMark[item] = '';
      }
      UserModel user = await UserService.instance.getUser();
      GameStatisticsModel model = GameStatisticsModel(
          registrationDate: DateTime.now().toString(), totalMark: totalMark, userName: user.userName);
      await _firestoreManager.insert(model, uid);
    } catch (e) {
      rethrow;
    }
  }
}
