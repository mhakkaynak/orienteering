import 'package:orienteering/core/init/firebase/firebase_stroge_manager.dart';

import '../../core/init/firebase/firestore_manager.dart';

abstract class BaseUserService {
  BaseUserService() {
    firestoreManager = FirestoreManager('user');
    strogeManager = StrogeManager('user');
  }

  late final FirestoreManager firestoreManager;
  late final StrogeManager strogeManager;
}
