  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'base_game_model.dart';

  class OutMapModel extends BaseGameModel{
    OutMapModel({
      required this.markerAdet,
      required this.score,
      required this.secondsPassed,
      required this.id,
      required this.markers,
      required this.joinedPlayers, // Add this line
    });

    int markerAdet;
    int score;
    int secondsPassed;
    String id;
    List<GeoPoint> markers;
    List<String> joinedPlayers; // And this line

    

    Map<String, dynamic> toJson() {
      return {
        'markerAdet': markerAdet,
        'score': score,
        'secondsPassed': secondsPassed,
        'id': id,
        'markers': markers.map((point) => {'lat': point.latitude, 'lng': point.longitude}).toList(),
        'joinedPlayers': joinedPlayers, // And this line
      };
    }

    factory OutMapModel.fromJson(Map<String, dynamic> json) {
      return OutMapModel(
        markerAdet: json['markerAdet'],
        score: json['score'],
        secondsPassed: json['secondsPassed'],
        id: json['id'],
        markers: (json['markers'] as List).map((point) => GeoPoint(point['lat'], point['lng'])).toList(),
        joinedPlayers: List<String>.from(json['joinedPlayers']), // And this line
      );
    }
  }
