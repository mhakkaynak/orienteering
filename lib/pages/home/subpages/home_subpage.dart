import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/widgets/app_bars/custom_search_bar.dart';

import '../../../core/init/navigation/navigation_manager.dart';
import '../../../model/user/user_model.dart';
import '../../../service/user/user_service.dart';

class HomeSubpage extends StatefulWidget {
  const HomeSubpage({super.key});

  @override
  State<HomeSubpage> createState() => _HomeSubpageState();
}

class _HomeSubpageState extends State<HomeSubpage> {
  UserModel _user = UserModel.empty();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await UserService.instance.getUser();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: Column(
          children: [
            _buildCityRow(context),
            
          ],
        ),
      ),
    );
  }

  Row _buildCityRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _user.cityString,
          style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        GestureDetector(
          onTap: _goToSearchPage,
          child: Row(
            children: [
              Text(
                'Şehir Değiştir',
                style: context.textTheme.labelSmall,
              ),
              Icon(
                Icons.arrow_forward_outlined,
                color: context.theme.primaryColor,
              )
            ],
          ),
        )
      ],
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(context.customHeightValue(0.08)),
      child: Padding(
        padding: EdgeInsets.only(top: context.customHeightValue(0.06)),
        child: CustomSearchBar(
          context: context,
          onPressed: _goToSearchPage,
          rightWidget: const CircleAvatar(
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  void _goToSearchPage() {
NavigationManager.instance
                .navigationToPage(NavigationConstant.search);
  }
}
