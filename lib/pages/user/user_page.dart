import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/service/user/user_auth_service.dart';

import '../../core/extensions/context_extension.dart';
import '../../core/extensions/string_extension.dart';
import '../../model/user/user_model.dart';
import '../../service/user/user_service.dart';
import '../../widgets/containers/secondary_color_container.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserModel _user = UserModel.empty();

  @override
  void initState() {
    _init();
    super.initState();
  }
  
  Padding _buildLogOutButton(BuildContext context) => Padding(
        padding: context.paddingNormalSymmetric,
        child: FilledButton(
            onPressed: () {
              UserAuthService.instance.signOut();
            },
            child: const Text('Çıkış yap')),
      );

  Padding _buildDivider(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: Divider(
            color: context.colors.onSecondaryContainer.withOpacity(0.5)),
      );

  Row _buildInfoLine(BuildContext context, String text1, String text2,
          {IconData? icon}) =>
      Row(
        children: [
          icon != null ? Icon(icon) : const SizedBox(width: 16),
          const SizedBox(width: 8),
          Text(
            text1,
            style: context.textTheme.titleSmall,
          ),
          const Spacer(),
          Text(
            text2,
            style: context.textTheme.labelMedium,
          ),
        ],
      );

  Container _buildContainer(BuildContext context) => SecondaryColorContainer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoText(context),
            const SizedBox(height: 16),
            _buildInfoLine(context, 'Level', _user.level!.toStringAsFixed(0),
                icon: Icons.brightness_7_outlined),
            _buildDivider(context),
            _buildInfoLine(context, 'Kredi', _user.coin.toString(),
                icon: Icons.monetization_on_outlined),
            _buildDivider(context),
            _buildInfoLine(context, 'Email', _user.email.toString(),
                icon: Icons.mail_outline),
            _buildDivider(context),
            _buildInfoLine(context, 'Şehir', _user.cityString,
                icon: Icons.location_city_outlined),
            _buildDivider(context),
            _buildInfoLine(context, 'Cinsiyet', _user.gender.toString(),
                icon: _user.gender.toString().toIcon),
            _buildDivider(context),
          ],
        ),
      );

  Row _buildInfoText(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bilgi',
            style: context.textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              NavigationManager.instance
                  .navigationToPage(NavigationConstant.userEdit);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      );

  Center _buildUserPicture() => const Center(
        child: CircleAvatar(
          minRadius: 75,
          maxRadius: 75,
          backgroundColor: Colors.black54,
        ),
      );

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await UserService.instance.getUser();
      setState(() {});
    });
  }

  SizedBox _buildSizedBoxLowHeight(BuildContext context) => SizedBox(
        height: context.lowHeightValue * 0.5,
      );

  Center _buildUserNameText(BuildContext context) => Center(
        child: Text(
          _user.userName ?? '',
          style: context.textTheme.displaySmall?.copyWith(color: Colors.black),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        body: Padding(
          padding: EdgeInsets.only(
            top: context.lowHeightValue,
            left: context.lowWidthValue,
            right: context.lowWidthValue,
          ),
          child: ListView(
            children: [
              _buildUserPicture(),
              _buildSizedBoxLowHeight(context),
              _buildUserNameText(context),
              _buildSizedBoxLowHeight(context),
              _user.userName != null
                  ? _buildContainer(context)
                  : const Center(child: CircularProgressIndicator()),
              _buildLogOutButton(context)
            ],
          ),
        ),
      );
}
