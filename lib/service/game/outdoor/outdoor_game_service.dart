import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/game/outdoor_game_model.dart';

class OutMapModelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'outdoor_games';

  Future<void> create(OutMapModel model) async {
    try {
      await _firestore.collection(_collectionPath).add(model.toJson());
    } catch (e) {
      throw Exception('Veri oluşturulurken hata oluştu: $e');
    }
  }

  Future<void> update(OutMapModel model, String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update(model.toJson());
    } catch (e) {
      throw Exception('Veri güncellenirken hata oluştu: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Veri silinirken hata oluştu: $e');
    }
  }
}
