import 'package:orienteering/model/game/base_game_model.dart';

class IndoorGameModel extends BaseGameModel {
  IndoorGameModel();

  IndoorGameModel._fromJson(o) {
    super.fromJson(o);
    qrList = List<String>.from(o['qrList']);
  }

  @override
  fromJson(json) => IndoorGameModel._fromJson(json);

  List<String>? qrList;

  @override
  Map<String, dynamic> toJson() => {
        'qrList': qrList,
      };
}
