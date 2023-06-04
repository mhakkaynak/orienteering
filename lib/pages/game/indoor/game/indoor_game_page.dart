import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/model/game/game_statistics_model.dart';
import 'package:orienteering/service/game/game_statistics_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../core/init/navigation/navigation_manager.dart';

class IndoorGamePage extends StatefulWidget {
  const IndoorGamePage({super.key});

  @override
  State<IndoorGamePage> createState() => _IndoorGamePageState();
}

class _IndoorGamePageState extends State<IndoorGamePage> {
  QRViewController? _controller;
  List<String> _flagList = [];
  final List<String> _foundFlagList = [];
  late final GameStatisticsService _gameStatisticService;
  GameStatisticsModel _gameStatisticsModel = GameStatisticsModel();
  String _gameTitle = '';
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _result;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data = ModalRoute.of(context)?.settings.arguments;
      setState(() {
        _gameTitle = data.toString();
      });
    });
    _init();
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  Future<void> _init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _gameStatisticService = GameStatisticsService(_gameTitle);
      _gameStatisticsModel = await _gameStatisticService.get();
      _flagList = _gameStatisticsModel.totalMark!.keys.toList();
      _gameStatisticsModel.startDate = DateTime.now().toString();
      _gameStatisticService.update(_gameStatisticsModel);
      setState(() {});
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) {
      _result = scanData;
      List<String> code = _result!.code.toString().split('|');
      String title = code[0];
      String info = code[1];
      if (_flagList.contains(title) && !_foundFlagList.contains(title)) {
        setState(() {
          _foundFlagList.add(title);
        });
        _gameStatisticsModel.totalMark![title] = DateTime.now().toString();
        if (_flagList.length == _foundFlagList.length) {
          showDialog(
            context: context,
            builder: (_) => _buildAlertDialog('Oyun Bitti!', 'Tebrikler'),
          );
          _gameStatisticsModel.endDate = DateTime.now().toString();
          _gameStatisticService.update(_gameStatisticsModel);
          NavigationManager.instance.navigationToPageClear(
              NavigationConstant.gameStatistics,
              args: _gameTitle);
        } else {
          showDialog(
            context: context,
            builder: (_) => _buildAlertDialog(info, 'İpucu'),
          );
          _gameStatisticService.update(_gameStatisticsModel);
        }
      }
    });
  }

  AlertDialog _buildAlertDialog(String info, String title) {
    return AlertDialog(
      backgroundColor: context.colors.secondaryContainer,
      title: Text(title),
      content: Text(info),
      actions: [
        IconButton(
          onPressed: () {
            NavigationManager.instance.navigationToPop();
          },
          icon: const Icon(Icons.check_outlined),
        )
      ],
    );
  }

  Center _buildFlagInfoContainer() => Center(
        child: Container(
          height: context.normalHeightValue,
          decoration: BoxDecoration(
            color: context.colors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(context.lowHeightValue * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFlagInfoText('Bayrak Sayısı: ${_flagList.length}'),
                _buildFlagInfoText(
                    'Toplanan Bayrak Sayısı: ${_foundFlagList.length}'),
              ],
            ),
          ),
        ),
      );

  Text _buildFlagInfoText(String text) => Text(
        text,
        style: context.textTheme.titleSmall,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: QRView(
                key: _qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildFlagInfoContainer(),
            ),
          ],
        ),
      ),
    );
  }
}
