import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/model/game/game_statistics_model.dart';

import '../../service/game/game_statistics_service.dart';

class GameStatisticsPage extends StatefulWidget {
  const GameStatisticsPage({super.key});

  @override
  State<GameStatisticsPage> createState() => _GameStatisticsPageState();
}

class _GameStatisticsPageState extends State<GameStatisticsPage> {
  String _gameTitle = '';
  List<GameStatisticsModel> _gamerRankList = [];
  Map<String, String> _totalMarkInfo = {};
  List<String> _totalMarkValues = [];
  List<String> _totalMarkKeys = [];
  late final GameStatisticsService _gameStatisticsService;
  @override
  void initState() {
    var data = ModalRoute.of(context)?.settings.arguments;
      _gameTitle = data.toString();
    _gameStatisticsService = GameStatisticsService(_gameTitle);
    _init();
    super.initState();
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _gamerRankList = await _gameStatisticsService.getRank();
      GameStatisticsModel model = await _gameStatisticsService.get();
      _totalMarkInfo = model.totalMark ?? {};
      _totalMarkValues = _totalMarkInfo.values.toList();
      _totalMarkKeys = _totalMarkInfo.keys.toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oyun Bitti'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingLowSymmetric,
          child: Column(
            children: [
              _buildContainer(
                'Oyuncu Sıralamaları',
                ListView.builder(
                  itemCount: _gamerRankList.length,
                  itemBuilder: (_, int index) {
                    GameStatisticsModel model = _gamerRankList[index];
                    return _buildListViewElement(context,
                        model.userName.toString(), (index + 1).toString());
                  },
                ),
              ),
              const SizedBox(height: 30),
              _buildContainer(
                'Oyun Özeti',
                ListView.builder(
                  itemCount: _totalMarkInfo.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildListViewElement(context, _totalMarkKeys[index],
                        _totalMarkValues[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildListViewElement(
      BuildContext context, String text1, String text2) {
    return Padding(
      padding: context.paddingLowSymmetric,
      child: Row(
        children: [
          Text(
            '$text1:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(text2),
        ],
      ),
    );
  }

  Container _buildContainer(String title, ListView listView) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: context.paddingNormalSymmetric,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(child: listView),
          ],
        ),
      ),
    );
  }
}
