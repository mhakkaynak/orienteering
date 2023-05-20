import 'base_game_model.dart';

class IndoorGameModel extends BaseGameModel {
  IndoorGameModel({
    this.qrList,
    this.location,
    required String date,
    required String description,
    String? organizerUid,
    List<String>? participantsUid,
    required String rules,
    required String title,
  }) : super(
          date: date,
          description: description,
          organizerUid: organizerUid,
          participantsUid: participantsUid,
          rules: rules,
          title: title,
        );

  IndoorGameModel._fromJson(o) {
    super.fromJson(o);
    qrList = Map<String, String>.from(o['qrList']);
    location = o['location'];
  }

  @override
  fromJson(json) => IndoorGameModel._fromJson(json);

  IndoorGameModel.empty();

  String? location;
  Map<String, String>? qrList;

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['qrList'] = qrList;
    map['location'] = location;
    return map;
  }
}
