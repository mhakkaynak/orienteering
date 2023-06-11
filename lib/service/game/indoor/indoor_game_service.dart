import '../../../model/game/base_game_model.dart';

import '../../../core/init/firebase/firebase_stroge_manager.dart';
import '../../../core/init/firebase/firestore_manager.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../model/game/indoor_game_model.dart';
import '../game_statistics_service.dart';
import '../../user/user_service.dart';

import '../../../core/constants/navigation/navigation_constant.dart';

class IndoorGameService {
  IndoorGameService._init() {
    _indoorGameFirestoreManager = FirestoreManager('indoor');
    _strogeManager = StrogeManager('indoorGame');
  }

  static IndoorGameService? _instance;

  late final FirestoreManager _indoorGameFirestoreManager;
  late final StrogeManager _strogeManager;

  static IndoorGameService get instance {
    _instance ??= IndoorGameService._init();
    return _instance!;
  }

  Future<String?> craeteGame(IndoorGameModel model) async {
    try {
      model.organizerUid = UserService.instance.uid;
      await _strogeManager.addImage(
          model.title.toString(), model.imagePath.toString());
      await _indoorGameFirestoreManager.insert(model, model.title!);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<List<BaseGameModel>> getAllGames() async {
    List<IndoorGameModel> games = [];
    try {
      var data = await _indoorGameFirestoreManager.getAll(
          model: IndoorGameModel.empty(), order: 'date');
      games = List<IndoorGameModel>.from(data);
      for (var i = 0; i < games.length; i++) {
        games[i].imagePath =
            await _strogeManager.getImage(games[i].title.toString());
      }
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
    return games;
  }

  Future<void> joinGame(IndoorGameModel model) async {
    try {
      String? uid = UserService.instance.uid;
      if (uid == null || model.participantsUid == null) {
        throw Exception();
      }
      model.participantsUid?.add(uid);
      await _indoorGameFirestoreManager.update(model, model.title.toString());
      await _addUserToGameStatistics(
          model.title.toString(), uid, model.qrList!.keys.toList());
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
  }

  Future<void> removeUser(IndoorGameModel model) async {
    try {
      String? uid = UserService.instance.uid;
      model.participantsUid!.remove(uid);
      await _indoorGameFirestoreManager.update(model, model.title.toString());
    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
  }

  Future<void> _addUserToGameStatistics(
      String title, String uid, List<String> keys) async {
    try {
      GameStatisticsService service = GameStatisticsService('indoor-$title');
      await service.insert(uid, keys);
    } catch (e) {
      rethrow;
    }
  }
}
