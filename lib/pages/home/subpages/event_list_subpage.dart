import 'package:flutter/material.dart';
import '../../../core/constants/navigation/navigation_constant.dart';
import '../../../core/init/navigation/navigation_manager.dart';
import '../../../model/game/base_game_model.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../model/game/indoor_game_model.dart';
import '../../../service/game/indoor/indoor_game_service.dart';
import '../../../widgets/card/game_card.dart';
import '../../../widgets/text_form_field/search_text_form_field.dart';

class EventListSubpage extends StatefulWidget {
  const EventListSubpage({super.key});

  @override
  State<EventListSubpage> createState() => _EventListSubpageState();
}

class _EventListSubpageState extends State<EventListSubpage> {
  final List<BaseGameModel> _gameList = [];
  List<IndoorGameModel> _indoorGameList = [];
  List<BaseGameModel> _searchGameList = [];
  final TextEditingController _searchTextController = TextEditingController();
  bool _isSearch = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _indoorGameList = await IndoorGameService.instance.getAllGames()
          as List<IndoorGameModel>;
      _gameList.addAll(_indoorGameList);
      setState(() {});
    });
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0.0,
        title: SearchTextFormField(
          controller: _searchTextController,
          onChanged: _searchOnChanged,
          cancelPressed: _searchCancelPressed,
        ),
      );

  void _searchCancelPressed() {
    setState(() {
      _searchTextController.text = '';
      FocusManager.instance.primaryFocus?.unfocus();
      _searchGameList = [];
      _isSearch = false;
      setState(() {});
    });
  }

  _searchOnChanged(text) {
    _searchGameList = [];
    for (var element in _gameList) {
      if (element.title!.contains(text)) {
        _searchGameList.add(element);
      }
    }
    _isSearch = true;
    setState(() {});
  }

  Padding _buildBody(BuildContext context) => Padding(
        padding: context.paddingLowSymmetric,
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: Padding(
                padding: context.paddingLowSymmetric,
                child: _buildListView(),
              ),
            ),
          ],
        ),
      );

  ListView _buildListView() => ListView.builder(
        itemCount: _isSearch ? _searchGameList.length : _gameList.length,
        itemBuilder: (BuildContext context, int index) {
          List<BaseGameModel> list = [];
          if (_isSearch) {
            list = _searchGameList;
          } else {
            list = _gameList;
          }

          String route = '';
          if (index <= _indoorGameList.length) {
            route = NavigationConstant.indoorGameDetail;
          }
          return _isSearch && list == []
              ? const Center(
                  child: Text('Sonuç Yok'),
                )
              : _buildCard(list[index], route);
        },
      );

  InkWell _buildCard(BaseGameModel model, String route) => InkWell(
        onTap: () {
          NavigationManager.instance.navigationToPage(route, args: model);
        },
        child: GameCard(
          context: context,
          imagePath: model.imagePath.toString(),
          title: model.title.toString(),
          description: model.description.toString(),
          location: model.location.toString(),
          date: model.date.toString(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }
}
