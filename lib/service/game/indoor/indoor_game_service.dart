import 'dart:ffi';

import 'package:orienteering/core/init/firebase/firestore_manager.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/model/game/game_statistics_model.dart';
import 'package:orienteering/model/game/indoor_game_model.dart';
import 'package:orienteering/service/game/game_statistics_service.dart';
import 'package:orienteering/service/user/user_service.dart';

import '../../../core/constants/navigation/navigation_constant.dart';

class IndoorGameService {
  IndoorGameService._init() {
    _indoorGameFirestoreManager = FirestoreManager('indoor');
  }

  static IndoorGameService? _instance;

  late final FirestoreManager _indoorGameFirestoreManager;

  static IndoorGameService get instance {
    _instance ??= IndoorGameService._init();
    return _instance!;
  }

  Future<String?> craeteGame(IndoorGameModel model) async {
    try {
      model.organizerUid = UserService.instance.uid;
      _indoorGameFirestoreManager.insert(model, model.title!);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<List<IndoorGameModel>> getAllGames() async {
    List<IndoorGameModel> games = [];
    try {
      var data = await _indoorGameFirestoreManager.getAll(
          model: IndoorGameModel.empty(), order: 'date');
      games = List<IndoorGameModel>.from(data);
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

  Future<void> _addUserToGameStatistics(
      String title, String uid, List<String> keys) async {
    try {
      GameStatisticsService service = GameStatisticsService('indoor-$title');
      await service.insert(uid, keys);
    } catch (e) {
      rethrow;
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
}
