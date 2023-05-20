import '../../core/base/base_model.dart';

class BaseGameModel extends BaseModel {
  BaseGameModel({
    this.date,
    this.description,
    this.organizerUid,
    this.participantsUid,
    this.rules,
    this.title,
  });

  String? date;
  String? description;
  String? organizerUid;
  List<String>? participantsUid;
  String? rules;
  String? title;

  @override
  fromJson(json) {
    date = json['date'].toString();
    description = json['description'].toString();
    organizerUid = json['organizerUid'].toString();
    participantsUid = List<String>.from(json['participantsUid']);
    rules = json['rules'].toString();
    title = json['title'].toString();
  }

  @override
  Map<String, dynamic> toJson() => {
        'date': date,
        'description': description,
        'organizerUid': organizerUid,
        'participantsUid': participantsUid,
        'rules': rules,
        'title': title,
      };
}
