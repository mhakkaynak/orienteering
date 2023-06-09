import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/game/outdoor_game_model.dart';

class OutMapModelService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _collectionPath = 'outdoor_games';

  Future<String> create(OutMapModel model) async {
    try {
      DocumentReference docRef = await _firestore.collection(_collectionPath).add(model.toJson());
      return docRef.id;
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
  static Future<List<OutMapModel>> getAll() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) => OutMapModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Veriler çekilirken hata oluştu: $e');
    }
  }
   static Future<OutMapModel> get(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collectionPath).doc(id).get();
      return OutMapModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Veri çekilirken hata oluştu: $e');
    }
  }

  static Future<void> joinGame(OutMapModel game, String playerId) async {
    try {
      game.joinedPlayers.add(playerId);
      await _firestore.collection(_collectionPath).doc(game.id).update(game.toJson());
    } catch (e) {
      throw Exception('Oyuna katılırken hata oluştu: $e');
    }
  }
 
}