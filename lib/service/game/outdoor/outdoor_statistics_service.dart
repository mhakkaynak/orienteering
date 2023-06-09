import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/game/outdoor_statistics_model.dart';

class PlayerStatsService {
  final _db = FirebaseFirestore.instance;

  Future<void> updatePlayerStats(String gameId, PlayerStats stats) async {
  await _db.collection('player_stats').doc(stats.userId).set({
    '$gameId': FieldValue.arrayUnion([stats.toMap()]),
  }, SetOptions(merge: true));
}

 Future<List<PlayerStats>> getPlayerStats(String userId, String gameId) async {
    DocumentSnapshot doc = await _db.collection('player_stats').doc(userId).get();
    if (!doc.exists) {
        // Belge yoksa, yeni bir belge oluşturun
        await _db.collection('player_stats').doc(userId).set({});
        doc = await _db.collection('player_stats').doc(userId).get();
    }
    List<PlayerStats> statsList = [];
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> statsMapList = List<Map<String, dynamic>>.from(data[gameId] ?? []);
    if(statsMapList != null) {
      for (var statsMap in statsMapList) {
          statsList.add(PlayerStats.fromMap(statsMap));
      }
    }
    return statsList;
}

}



