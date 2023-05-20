import 'package:orienteering/core/init/firebase/firestore_manager.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/model/game/indoor_game_model.dart';
import 'package:orienteering/service/user/user_service.dart';

import '../../../core/constants/navigation/navigation_constant.dart';

class IndoorGameService {
  IndoorGameService._init() {
    _firestoreManager = FirestoreManager('indoor');
  }

  late final FirestoreManager _firestoreManager;
  static IndoorGameService? _instance;

  static IndoorGameService get instance {
    _instance ??= IndoorGameService._init();
    return _instance!;
  }

  Future<String?> craeteGame(IndoorGameModel model) async {
    try {
      model.organizerUid = UserService.instance.uid;
      _firestoreManager.insert(model, model.title!);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<List<IndoorGameModel>> getAllGames() async {
    List<IndoorGameModel> games = [];
    try {
      var data = await _firestoreManager.getAll(
          model: IndoorGameModel.empty(), order: 'date');
      games = List<IndoorGameModel>.from(data);

    } catch (e) {
      NavigationManager.instance
          .navigationToPageClearWithDelay(NavigationConstant.error);
    }
    return games;
  }
}
