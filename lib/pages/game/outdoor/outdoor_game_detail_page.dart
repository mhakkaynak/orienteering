import 'package:flutter/material.dart';
import '../../../../core/constants/navigation/navigation_constant.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';
import '../../../../service/user/user_service.dart';
import '../../../model/game/outdoor_game_model.dart';
import '../../../service/game/outdoor/outdoor_game_service.dart';

class OutdoorGameDetailPage extends StatefulWidget {
  const OutdoorGameDetailPage({super.key});

  @override
  State<OutdoorGameDetailPage> createState() => _OutdoorGameDetailPageState();
}

class _OutdoorGameDetailPageState extends State<OutdoorGameDetailPage> {
  OutMapModel? _game;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        _game = data as OutMapModel;
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
          SizedBox(height: context.lowWidthValue * 1.5),
          Text(
            _game!.gametitle.toString(),
            style: context.textTheme.titleLarge,
          ),
          const Divider(),
          SizedBox(height: context.lowWidthValue),
          _buildRichText(context, Icons.calendar_month_outlined, ' ${_game?.selectedDateTime.toString().substring(0, _game!.selectedDateTime.toString().length - 7)}'),
          SizedBox(height: context.lowWidthValue),
          _buildRichText(context, Icons.location_on_outlined, 'Kocaeli'),
          SizedBox(height: context.lowWidthValue),
          const Divider(),
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
    String userUid = UserService.instance.uid.toString();
    if (!_game!.joinedPlayers.contains(userUid)) {
      await OutMapModelService.joinGame(_game!, userUid);
      setState(() {});
      NavigationManager.instance.navigationToPage(
          NavigationConstant.outdoorPlayGame,
          args: 'outdoor-${_game?.id}');
    } else {
      print('You are already a participant of this game.');
    }
  },
  child: const Text('Katıl'),
)
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

  Widget _buildButton() {
    String userUid = UserService.instance.uid.toString();
    if (!_game!.joinedPlayers.contains(userUid)) {
      return _buildJoinButton();
    } else {
      return Text('Zaten bu oyunun katılımcılarından birisisin',
          style: context.textTheme.bodyMedium);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
