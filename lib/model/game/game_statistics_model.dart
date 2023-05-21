import '../../core/base/base_model.dart';

class GameStatisticsModel extends BaseModel {
  GameStatisticsModel({this.endDate, this.registrationDate, this.startDate, this.totalMark});

  GameStatisticsModel._fromJson(o) {
    endDate = o['endDate'];
    registrationDate = o['registrationDate'];
    startDate = o['startDate'];
    totalMark = Map<String, String>.from(o['totalMark']);
  }

  @override
  fromJson(json) => GameStatisticsModel._fromJson(json);

  GameStatisticsModel.empty();

  String? endDate;
  String? registrationDate;
  String? startDate;
  Map<String, String>? totalMark;

  @override
  Map<String, dynamic> toJson() => {
        'endDate': endDate,
        'registrationDate': registrationDate,
        'startDate': startDate,
        'totalMark': totalMark,
      };
}
