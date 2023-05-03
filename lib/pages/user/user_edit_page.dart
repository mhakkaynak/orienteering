import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/extensions/string_extension.dart';
import '../../widgets/buttons/enabled_text_form_field_button.dart';

import '../../core/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../model/user/user_model.dart';
import '../../service/location/location_service.dart';
import '../../service/user/user_service.dart';
import '../../widgets/bottom_bars/cupertino_bottom_picker.dart';
import '../../widgets/snack_bars/error_snack_bar.dart';
import '../../widgets/text_form_field/user_name_text_form_field.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  late final List<String> _cities;
  late String _gender;
  final List<String> _genderList = ['Kadın', 'Erkek', 'Diğer'];
  late int _licensePlate;
  UserModel _user = UserModel.empty();
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
    _gender = _user.gender ?? 'Erkek';
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

  AppBar _buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Düzenle'),
        actions: [
          IconButton(
            onPressed: _editOnPressed,
            icon: const Icon(Icons.check_outlined),
          )
        ],
      );

  Future<void> _editOnPressed() async {
    _user.userName = _userNameController.text;
    _user.gender = _gender;
    _user.city = _licensePlate + 1;
    var response = await UserService.instance.updateUser(_user);
    if (response != '' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
        context: context,
        text: response,
      ));
    } else {
      NavigationManager.instance.navigationToPageClear(NavigationConstant.home);
    }
  }

  Column _buildColumn(BuildContext context) => Column(
        children: [
          const CircleAvatar(
            // TODO: duzeltilecek
            minRadius: 75,
            maxRadius: 75,
            backgroundColor: Colors.black54,
          ),
          SizedBox(height: context.lowHeightValue),
          UserNameTextFormField(controller: _userNameController),
          SizedBox(height: context.lowHeightValue * 0.5),
          EnabledTextFormFieldButton(
              context: context,
              text: 'Kredi: ${_user.coin}',
              icon: Icons.monetization_on_outlined,
              onTap: _coinOnTap),
          SizedBox(height: context.lowHeightValue * 0.5),
          EnabledTextFormFieldButton(
              context: context,
              text: 'Cinsiyet: $_gender',
              icon: _gender.toString().toIcon!,
              onTap: _genderOnTap),
          SizedBox(height: context.lowHeightValue * 0.5),
          EnabledTextFormFieldButton(
              context: context,
              text: 'Şehir: ${_cities[_licensePlate]}',
              icon: Icons.location_city_outlined,
              onTap: _cityOnTap),
        ],
      );

  void _genderOnTap() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoBottomPicker(
              context: context,
              initialItem: _genderList.indexOf(_gender),
              onSelectedItemChanged: (int value) {
                setState(() {
                  _gender = _genderList[value];
                });
              },
              cancelOnPressed: () {
                setState(() {
                  _gender = _user.gender ?? 'Erkek';
                });
              },
              children: _buildTextList(_genderList),
            ));
  }

  void _cityOnTap() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoBottomPicker(
              context: context,
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
  }

  void _coinOnTap() {}

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: _user.userName != null
            ? _buildColumn(context)
            : const Center(child: CircularProgressIndicator()),
      ));
}
