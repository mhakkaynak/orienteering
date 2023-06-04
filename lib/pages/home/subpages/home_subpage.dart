import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/app/app_constant.dart';

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
      _indoorGameList = await IndoorGameService.instance.getAllGames()
          as List<IndoorGameModel>;
      setState(() {});
    });
  }

  Padding _buildBody() {
    return Padding(
      padding: context.paddingLowSymmetric,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildCityRow(context),
          SizedBox(
            height: context.lowHeightValue,
          ),
          _buildOrienteeringContainer(),
          SizedBox(
            height: context.lowHeightValue,
          ),
          Text(
            'Indoor Oyunlar',
            style: context.textTheme.titleSmall,
          ),
          SizedBox(
            height: context.lowHeightValue * 0.4,
          ),
          _buildListView()
        ],
      ),
    );
  }

  SizedBox _buildListView() {
    return SizedBox(
      height: context.customHeightValue(0.3),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _indoorGameList.length,
        itemBuilder: (BuildContext context, int index) {
          var indoorGame = _indoorGameList[index];
          return _buildGameContainer(
              context, indoorGame, NavigationConstant.indoorGameDetail);
        },
      ),
    );
  }

  GestureDetector _buildGameContainer(
      BuildContext context, IndoorGameModel game, String route) {
    return GameContainer(
      context: context,
      dateText: game.date.toString(),
      imagePath: game.imagePath ?? 'https://picsum.photos/200/300',
      titleText: game.title.toString(),
      locationText: game.location.toString(),
      onTap: () {
        NavigationManager.instance.navigationToPage(route, args: game);
      },
    );
  }

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

  PreferredSize _buildAppBar() {
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
          rightWidget: CircleAvatar(
            backgroundImage: NetworkImage(
              _user.imagePath ?? 'https://picsum.photos/200/300',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Stack _buildOrienteeringContainer() => Stack(
        children: [
          _buildOrienteeringImage(),
          _buildWhatIsOrienteeringButton(),
        ],
      );

  ClipRRect _buildOrienteeringImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32.0),
      child: Image.asset(
        AppConstant.orienteeringImage,
        fit: BoxFit.fill,
        height: 200,
        width: double.infinity,
      ),
    );
  }

  Positioned _buildWhatIsOrienteeringButton() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          onPressed: () {
            NavigationManager.instance
                .navigationToPage(NavigationConstant.orienteeringExplanation);
          },
          child: Text(
            'Oryantiring Nedir?',
            style: TextStyle(
              fontSize: 20,
              color: context.colors.tertiaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
