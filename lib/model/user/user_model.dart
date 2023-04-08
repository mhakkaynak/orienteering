import '../../core/base/base_model.dart';

class UserModel extends BaseModel {
  UserModel(
    this.userName,
    this.email,
    this.city,
    this.uid,
    this.coin,
  );

  UserModel._fromJson(o) {
    userName = o['userName'];
    email = o['email'];
    uid = o['uid'];
    city = int.tryParse(o['city'].toString());
    coin = int.tryParse(o['coin'].toString());
  }

  @override
  fromJson(json) => UserModel._fromJson(json);

  UserModel.empty();

  UserModel.register({
    this.userName,
    this.email,
    this.password,
  });

  int? city;
  int? coin;
  String? email;
  String? password;
  String? uid;
  String? userName;

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'city': city,
        'uid': uid,
        'coin': coin,
      };
}