import 'base_game_model.dart';

class OutMapModel extends BaseGameModel {
  int markerAdet;
  int score;
  int secondsPassed;
  String id;

  OutMapModel({
    required this.markerAdet,
    required this.score,
    required this.secondsPassed,
    required this.id,
    String? date,
    String? description,
    String? organizerUid,
    List<String>? participantsUid,
    String? rules,
    String? title,
  }) : super(
          date: date,
          description: description,
          organizerUid: organizerUid,
          participantsUid: participantsUid,
          rules: rules,
          title: title,
        );

  @override
  void fromJson(json) {
    super.fromJson(json);
    markerAdet = json['markerAdet'] ?? 0;
    score = json['score'] ?? 0;
    secondsPassed = json['secondsPassed'] ?? 0;
  }

 

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['markerAdet'] = markerAdet;
    map['score'] = score;
    map['secondsPassed'] = secondsPassed;
    return map;
  }
}
