import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/extensions/context_extension.dart';
import '../../model/game/game_statistics_model.dart';

class OrganizerPanelPage extends StatefulWidget {
  const OrganizerPanelPage({super.key});

  @override
  State<OrganizerPanelPage> createState() => _OrganizerPanelPageState();
}

class _OrganizerPanelPageState extends State<OrganizerPanelPage> {
  bool _isStart = false;
  final Stopwatch _stopwatch = Stopwatch();
  String _strTimer = '00:00:00';
  late Timer _timer;
  String _title = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        _title = data.toString();
      });
    });
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _strTimer =
            '${_stopwatch.elapsed.inHours.toString().padLeft(2, '0')}:${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  void _stopTimer() {
    _timer.cancel();
    _stopwatch.stop();
  }

  ElevatedButton _buildElevationButton() => _isStart
      ? ElevatedButton(
          onPressed: () {
            _stopTimer();
          },
          child: _buildTextInsideButton('Oyunu Bitir'),
        )
      : ElevatedButton(
          onPressed: () {
            setState(() {
              _isStart = true;
            });
            _startTimer();
          },
          child: _buildTextInsideButton('Oyunu Başlat'),
        );

  Text _buildTextInsideButton(String text) => Text(
        text,
        style: context.textTheme.titleSmall,
      );

  Container _buildPlayersTableContainer() {
    return Container(
      height: context.customHeightValue(0.4),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: context.paddingNormalSymmetric,
        child: _title != ''
            ? _buildStreamBuilder()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _buildStreamBuilder() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(_title).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var items = snapshot.data?.docs ?? [];
          List<GameStatisticsModel> gameStatisticsList = [];
          GameStatisticsModel gameStatisticsModel = GameStatisticsModel();
          for (var item in items) {
            gameStatisticsList.add(gameStatisticsModel.fromJson(item));
          }
          return SingleChildScrollView(
            child: Table(
              children: _buildTableChildren(gameStatisticsList),
            ),
          );
        });
  }

  Container _buildTimerContainer() {
    return Container(
      height: context.normalHeightValue * 0.6,
      width: context.customWidthValue(0.5),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Text(
          _strTimer,
          style: context.textTheme.displaySmall
              ?.copyWith(color: context.colors.onSecondaryContainer),
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> list, {int? index}) => TableRow(
      children: list
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  e,
                  style: index == 0
                      ? context.textTheme.titleSmall
                      : context.textTheme.labelMedium,
                )),
              ))
          .toList());

  List<TableRow> _buildTableChildren(
      List<GameStatisticsModel> gameStatisticsList) {
    List<TableRow> list = [];
    list.add(_buildTableRow(['Kullanıcı Adı', 'Puan'], index: 0));
    for (var model in gameStatisticsList) {
      int puan = 0;
      if (model.totalMark != null) {
        for (var mark in model.totalMark!.values) {
          if (mark != '') puan++;
        }
      }
      list.add(_buildTableRow([model.userName.toString(), puan.toString()]));
    }
    return list;
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: context.paddingLowSymmetric,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayersTableContainer(),
          _buildTimerContainer(),
          _buildElevationButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}
