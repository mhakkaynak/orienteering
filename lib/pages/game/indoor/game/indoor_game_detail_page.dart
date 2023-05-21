import 'package:flutter/material.dart';
import '../../../../core/constants/navigation/navigation_constant.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';
import '../../../../model/game/indoor_game_model.dart';
import '../../../../service/game/indoor/indoor_game_service.dart';
import '../../../../service/user/user_service.dart';

class IndoorGameDetailPage extends StatefulWidget {
  const IndoorGameDetailPage({super.key});

  @override
  State<IndoorGameDetailPage> createState() => _IndoorGameDetailPageState();
}

class _IndoorGameDetailPageState extends State<IndoorGameDetailPage> {
  IndoorGameModel _game = IndoorGameModel.empty();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        _game = data as IndoorGameModel;
      });
    });
    super.initState();
  }

  Padding _buildBody() => Padding(
        padding: context.paddingLowSymmetric,
        child: _buildColumn(),
      );

  Column _buildColumn() => Column(
        children: [
          const SizedBox(height: 200, child: Placeholder()),
          SizedBox(height: context.lowWidthValue * 1.5),
          Text(
            _game.title.toString(),
            style: context.textTheme.titleLarge,
          ),
          const Divider(),
          SizedBox(height: context.lowWidthValue),
          _buildRichText(
              context, Icons.calendar_month_outlined, ' ${_game.date}'),
          SizedBox(height: context.lowWidthValue),
          _buildRichText(
              context, Icons.location_on_outlined, ' ${_game.location}'),
          SizedBox(height: context.lowWidthValue),
          const Divider(),
          _buildTabController(),
          const Spacer(),
          const Divider(),
          _buildBottomArea()
        ],
      );

  Padding _buildBottomArea() => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.lowWidthValue * 2.4,
            vertical: context.height * 0.006),
        child: _buildButton(),
      );

  Row _buildJoinButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Katılmak ister misin?',
            style: context.textTheme.labelSmall,
          ),
          ElevatedButton(
              onPressed: () async {
                IndoorGameService.instance.joinGame(_game);
                setState(() {});
                NavigationManager.instance.navigationToPage(
                    NavigationConstant.indoorGame,
                    args: 'indoor-${_game.title}');
              },
              child: const Text('Katıl')),
        ],
      );

  AppBar _buildAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Align _buildRichText(BuildContext context, IconData icon, String text) =>
      Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  icon,
                  size: 18,
                ),
              ),
              TextSpan(
                text: text,
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );

  DefaultTabController _buildTabController() => DefaultTabController(
        length: 2, // length of tabs
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const TabBar(
              tabs: [
                Tab(text: 'Açıklama'),
                Tab(text: 'Kurallar'),
              ],
            ),
            SizedBox(
              height: context.customWidthValue(0.6), //height of TabBarView
              child: TabBarView(
                children: <Widget>[
                  _buildTextInsideTab(_game.description.toString()),
                  _buildTextInsideTab(_game.rules.toString()),
                ],
              ),
            )
          ],
        ),
      );

  SingleChildScrollView _buildTextInsideTab(String text) =>
      SingleChildScrollView(
        child: Padding(
          padding: context.paddingNormalSymmetric,
          child: Text(text),
        ),
      );

  Widget _buildButton() {
    String userUid = UserService.instance.uid.toString();
    String organizerUid = _game.organizerUid.toString();
    if (userUid == organizerUid) {
      return _buildStartGame();
    } else if (_game.participantsUid != null && 
        _game.participantsUid!.contains(userUid)) {
      return _buildCancelButton();
    } else {
      return _buildJoinButton();
    }
  }

  ElevatedButton _buildStartGame() {
    return ElevatedButton(
      onPressed: () {
        NavigationManager.instance.navigationToPage(
            NavigationConstant.organizerPanel,
            args: 'indoor-${_game.title}');
      },
      child: const Text('Oyunu başlat'),
    );
  }

  Widget _buildCancelButton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'İptal etmek ister misin?',
            style: context.textTheme.labelSmall,
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await IndoorGameService.instance.removeUser(_game);
              setState(() {});
            },
            label: const Text('İptal et'),
            icon: const Icon(Icons.cancel_outlined),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
