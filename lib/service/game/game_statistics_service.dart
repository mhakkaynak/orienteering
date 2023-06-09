import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/service/user/user_service.dart';

import '../../core/init/firebase/firestore_manager.dart';
import '../../core/init/navigation/navigation_manager.dart';
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
          registrationDate: DateTime.now().toString(),
          totalMark: totalMark,
          userName: user.userName);
      await _firestoreManager.insert(model, uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<GameStatisticsModel> get() async {
    GameStatisticsModel model = GameStatisticsModel();
    try {
      model = await _firestoreManager.get(UserService.instance.uid.toString(),
          model: model) as GameStatisticsModel;
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error); 
    }
    return model;
  }

  Future<List<GameStatisticsModel>> getRank() async {
    List<GameStatisticsModel> list = [];
    try {
      var data = await _firestoreManager.getAll(
          model: GameStatisticsModel.empty(), order: 'endDate');
      list = List<GameStatisticsModel>.from(data);
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
    return list;
  }

  Future<void> update(GameStatisticsModel model) async {
    try {
      await _firestoreManager.update(
          model, UserService.instance.uid.toString());
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
  }
}
