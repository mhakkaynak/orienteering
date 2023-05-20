import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/model/game/indoor_game_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      } else if (data is Map<String, String>) {
        _qrList = data;
        setState(() {});
      }
    });

    super.initState();
  }

  Padding _buildBody() {
    return Padding(
      padding: context.paddingNormalSymmetric,
      child: GridView.builder(
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
      ),
    );
  }

  FloatingActionButton _buildFab(int index, bool isQr) {
    return FloatingActionButton(
      heroTag: 'btn$index',
      onPressed: () {
        _fabOnPressed(isQr, index);
      },
      child: isQr ? _buildQrColumn(index) : const Icon(Icons.add_outlined),
    );
  }

  void _fabOnPressed(bool isQr, int index) {
    if (isQr) {
      showDialog(
        context: context,
        builder: (_) => _buildAlertDialog(index),
      );
    } else {
      NavigationManager.instance
          .navigationToPage(NavigationConstant.qrCreate, args: _qrList);
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
      title: Text('Qr Kod Sil'),
      content: Text('Bu Qr kod silinsin mi?'),
      actions: [_buildAlertIconButton(index)],
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

  void _createGame() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
