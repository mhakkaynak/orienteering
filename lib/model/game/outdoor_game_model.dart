  import 'package:cloud_firestore/cloud_firestore.dart';

  import 'base_game_model.dart';

  class OutMapModel extends BaseGameModel{
    OutMapModel({
      required this.markerAdet,
      required this.id,
      required this.selectedDateTime,
      required this.gametitle,
      required this.markers,
      required this.joinedPlayers, // Add this line
    });

    int markerAdet;
    String id;
    DateTime? selectedDateTime;
    String gametitle;
    List<GeoPoint> markers;
    List<String> joinedPlayers; // And this line

    

    Map<String, dynamic> toJson() {
      return {
        'markerAdet': markerAdet,
        'id': id,
        'date': selectedDateTime?.toIso8601String(),
        'gametitle': gametitle,
        'markers': markers.map((point) => {'lat': point.latitude, 'lng': point.longitude}).toList(),
        'joinedPlayers': joinedPlayers, // And this line
      };
    }

    factory OutMapModel.fromJson(Map<String, dynamic> json) {
      return OutMapModel(
        markerAdet: json['markerAdet'],
        id: json['id'],
        selectedDateTime: DateTime.parse(json['date']),
        gametitle: json['gametitle'],
        markers: (json['markers'] as List).map((point) => GeoPoint(point['lat'], point['lng'])).toList(),
        joinedPlayers: List<String>.from(json['joinedPlayers']), // And this line
      );
    }
  }
