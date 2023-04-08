import '../../core/base/base_model.dart';

class UserModel extends BaseModel {
  UserModel(
    this.userName,
    this.email,
    this.city,
    this.uid,
    this.coin,
  );

  UserModel.empty();

  UserModel._fromJson(o) {
    userName = o['userName'];
    email = o['email'];
    uid = o['uid'];
    city = int.tryParse(o['city'].toString());
    coin = int.tryParse(o['coin'].toString());
  }

  String? userName;
  String? email;
  int? city;
  String? uid;
  int? coin;

  @override
  fromJson(json) => UserModel._fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'city': city,
        'uid': uid,
        'coin': coin,
      };
}
