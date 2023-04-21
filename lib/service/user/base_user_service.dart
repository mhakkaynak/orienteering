import '../../core/init/firebase/firestore_manager.dart';

abstract class BaseUserService {
  BaseUserService() {
    firestoreManager = FirestoreManager('user');
  }

  late final FirestoreManager firestoreManager;
}
