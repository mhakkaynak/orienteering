import 'dart:io';

import 'package:orienteering/core/base/base_model.dart';

// TODO: Burada oyunlardaki genel bilgilerde yer alacak!
abstract class BaseGameModel extends BaseModel {
  String? organizerUid;
  List<String>? participantsUid;

  @override
  fromJson(json) {
    organizerUid = json['organizerUid'].toString();
    participantsUid = List<String>.from(json['participantsUid']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'organizerUid': organizerUid,
        'participantsUid': participantsUid,
      };
}
