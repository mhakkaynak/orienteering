import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/service/location/location_service.dart';
import 'package:orienteering/service/user/user_service.dart';
import 'package:orienteering/widgets/bottom_bars/cupertino_bottom_picker.dart';
import 'package:orienteering/widgets/text_form_field/user_name_text_form_field.dart';

import '../../model/user/user_model.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  late final List<String> _cities;
  final List<String> _gender = ['Kadın', 'Erkek', 'Diğer'];
  UserModel _user = UserModel.empty();
  late int _licensePlate;

  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _user = await UserService.instance.getUser();
    _cities = await LocationService.instance.getCities();
    _userNameController.text = _user.userName.toString();
    _licensePlate = _user.city != null ? _user.city! - 1 : 41;
    setState(() {});
  }

  List<Widget> _buildTextList(List<String> list) {
    List<Widget> widgetList = [];
    for (var item in list) {
      widgetList.add(
        Center(child: Text(item)),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text('Düzenle'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check_outlined),
            )
          ],
        ),
        body: Padding(
          padding: context.paddingLowSymmetric,
          child: _user.userName != null
              ? ListView(
                  children: [
                    CircleAvatar(
                      minRadius: 75,
                      maxRadius: 75,
                      backgroundColor: Colors.black54,
                    ),
                    UserNameTextFormField(controller: _userNameController),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {},
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          hintText: 'Kredi: ${_user.coin}',
                          fillColor: context.colors.surfaceVariant,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (_) => CupertinoBottomPicker(
                                  context: context,
                                  height: 0.16,
                                  children: _buildTextList(_gender),
                                  onSelectedItemChanged: (int value) {},
                                ));
                      },
                      child: TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          hintText: 'Cinsiyet: ${_user.gender}',
                          fillColor: context.colors.surfaceVariant,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildCitiesWidget(context),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ));
  }

  GestureDetector _buildCitiesWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
            context: context,
            builder: (_) => CupertinoBottomPicker(
                  context: context,
                  looping: true,
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      _licensePlate = value;
                    });
                  },
                  cancelOnPressed: () {
                    setState(() {
                      if (_user.city != null) {
                        _licensePlate = _user.city! - 1;
                      }
                    });
                  },
                  initialItem: _licensePlate,
                  children: _buildTextList(_cities),
                ));
      },
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.monetization_on_outlined),
          hintText: 'Şehir: ${_cities[_licensePlate]}',
          fillColor: context.colors.surfaceVariant,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
