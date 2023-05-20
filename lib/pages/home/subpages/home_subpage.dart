import 'package:flutter/material.dart';

import '../../../core/constants/navigation/navigation_constant.dart';
import '../../../core/extensions/context_extension.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../model/game/indoor_game_model.dart';
import '../../../model/user/user_model.dart';
import '../../../service/game/indoor/indoor_game_service.dart';
import '../../../service/user/user_service.dart';
import '../../../widgets/app_bars/custom_search_bar.dart';
import '../../../widgets/containers/game_container.dart';

class HomeSubpage extends StatefulWidget {
  const HomeSubpage({super.key});

  @override
  State<HomeSubpage> createState() => _HomeSubpageState();
}

class _HomeSubpageState extends State<HomeSubpage> {
  List<IndoorGameModel> _indoorGameList = [];
  UserModel _user = UserModel.empty();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _user = await UserService.instance.getUser();
      _indoorGameList = await IndoorGameService.instance.getAllGames();
      setState(() {});
    });
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: context.paddingLowSymmetric,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildCityRow(context),
          SizedBox(
            height: context.lowHeightValue,
          ),
          const Placeholder(
            fallbackHeight: 200,
          ),
          SizedBox(
            height: context.lowHeightValue,
          ),
          _indoorGameList != []
              ? _buildIndoorGameList(context)
              : const SizedBox(),
        ],
      ),
    );
  }

  SizedBox _buildIndoorGameList(BuildContext context) {
    return SizedBox(
      height: context.customHeightValue(0.36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Indoor Oyunlar',
            style: context.textTheme.titleSmall,
          ),
          SizedBox(
            height: context.lowHeightValue * 0.4,
          ),
          _buildListView(),
        ],
      ),
    );
  }

  Expanded _buildListView() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _indoorGameList.length,
        itemBuilder: (BuildContext context, int index) {
          var indoorGame = _indoorGameList[index];
          return _buildGameContainer(
              context,
              indoorGame.date.toString(),
              indoorGame.title.toString(),
              indoorGame.location.toString(),
              NavigationConstant.indoorGameDetail);
        },
      ),
    );
  }

  GestureDetector _buildGameContainer(BuildContext context, String dateText,
          String titleText, String locationText, String route) =>
      GameContainer(
        context: context,
        dateText: dateText,
        titleText: titleText,
        locationText: locationText,
        onTap: () {
          NavigationManager.instance.navigationToPage(route);
        },
      );

  Row _buildCityRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _user.cityString,
          style: context.textTheme.titleSmall,
        ),
        GestureDetector(
          onTap: () {
            NavigationManager.instance
                .navigationToPage(NavigationConstant.userEdit);
          },
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
      preferredSize: Size.fromHeight(context.customHeightValue(0.09)),
      child: Padding(
        padding: EdgeInsets.only(top: context.customHeightValue(0.06)),
        child: CustomSearchBar(
          context: context,
          onPressed: () {
            NavigationManager.instance
                .navigationToPage(NavigationConstant.eventList);
          },
          rightWidget: const CircleAvatar(
            backgroundColor: Colors.amber,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
