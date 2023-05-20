import 'package:orienteering/core/init/firebase/firestore_manager.dart';
import 'package:orienteering/model/game/indoor_game_model.dart';
import 'package:orienteering/service/user/user_service.dart';

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
}
