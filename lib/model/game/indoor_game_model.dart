import 'base_game_model.dart';

class IndoorGameModel extends BaseGameModel {
  IndoorGameModel({
    this.qrList,
    String? location,
    required String date,
    required String description,
    String? organizerUid,
    List<String>? participantsUid,
    required String rules,
    required String title,
    required String imagePath,
  }) : super(
          date: date,
          description: description,
          organizerUid: organizerUid,
          participantsUid: participantsUid,
          rules: rules,
          title: title,
          imagePath: imagePath,
        );

  IndoorGameModel._fromJson(o) {
    qrList = Map<String, String>.from(o['qrList']);
    location = o['location'].toString();
    super.fromJson(o);
  }

  @override
  fromJson(json) => IndoorGameModel._fromJson(json);

  IndoorGameModel.empty();

  Map<String, String>? qrList;

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map['qrList'] = qrList;
    map['location'] = location;
    return map;
  }
}
