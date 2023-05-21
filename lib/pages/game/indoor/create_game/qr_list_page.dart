import 'package:flutter/material.dart';
import 'package:orienteering/service/game/indoor/indoor_game_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/navigation/navigation_constant.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';
import '../../../../model/game/indoor_game_model.dart';
import '../../../../widgets/snack_bars/error_snack_bar.dart';

class QrListPage extends StatefulWidget {
  const QrListPage({super.key});

  @override
  State<QrListPage> createState() => _QrListPageState();
}

class _QrListPageState extends State<QrListPage> {
  IndoorGameModel _gameModel = IndoorGameModel.empty();
  Map<String, String> _qrList = {};

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data = ModalRoute.of(context)?.settings.arguments;
      if (data is IndoorGameModel) {
        _gameModel = data;
        _qrList = _gameModel.qrList ?? {};
      }
    });
    super.initState();
  }

  Padding _buildBody() {
    return Padding(
      padding: context.paddingNormalSymmetric,
      child: _buildQrList(),
    );
  }

  GridView _buildQrList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: _qrList.length + 1,
      itemBuilder: (BuildContext _, index) {
        bool isQr = index < _qrList.length;
        return _buildFab(index, isQr);
      },
    );
  }

  FloatingActionButton _buildFab(int index, bool isQr) => FloatingActionButton(
        heroTag: 'btn$index',
        onPressed: () {
          _fabOnPressed(isQr, index);
        },
        child: isQr ? _buildQrColumn(index) : const Icon(Icons.add_outlined),
      );

  void _fabOnPressed(bool isQr, int index) {
    if (isQr) {
      showDialog(
        context: context,
        builder: (_) => _buildAlertDialog(index),
      );
    } else {
      NavigationManager.instance
          .navigationToPage(NavigationConstant.qrCreate, args: _gameModel);
    }
  }

  Column _buildQrColumn(int index) {
    return Column(
      children: [
        QrImageView(
          data: _qrList.values.elementAt(index),
          size: 140,
        ),
        Text(
          _qrList.keys.elementAt(index),
          style: context.textTheme.labelMedium,
        ),
      ],
    );
  }

  AlertDialog _buildAlertDialog(int index) {
    return AlertDialog(
      backgroundColor: context.colors.secondaryContainer,
      title: const Text('Qr Kod Sil'),
      content: const Text('Bu Qr kod silinsin mi?'),
      actions: [
        _buildAlertIconButton(index),
      ],
    );
  }

  IconButton _buildAlertIconButton(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          _qrList.remove(_qrList.keys.elementAt(index));
        });
        NavigationManager.instance.navigationToPop();
      },
      icon: const Icon(Icons.check_outlined),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Qr Oluştur'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: _createGame, icon: const Icon(Icons.check_outlined))
      ],
    );
  }

  Future<void> _createGame() async {
    _gameModel.qrList = _qrList;
    var response = await IndoorGameService.instance.craeteGame(_gameModel);
    if (response != null) {
      _showError('Bir hata oluştu lütfen tekrar deneyiniz.');
    } else {
      NavigationManager.instance.navigationToPage(NavigationConstant.home);
    }
  }

  void _showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
