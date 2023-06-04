import '../../core/base/base_model.dart';

class BaseGameModel extends BaseModel {
  BaseGameModel({
    this.date,
    this.description,
    this.imagePath,
    this.organizerUid,
    this.participantsUid,
    this.rules,
    this.title,
  });

  String? date;
  String? description;
  String? imagePath;
  String? organizerUid;
  List<String>? participantsUid;
  String? rules;
  String? title;
  String? location;

  @override
  fromJson(json) {
    date = json['date'].toString();
    description = json['description'].toString();
    imagePath = json['imagePath'].toString();
    organizerUid = json['organizerUid'].toString();
    participantsUid = json['participantsUid'] != null
        ? List<String>.from(json['participantsUid'])
        : [];
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
