import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../../../../core/constants/navigation/navigation_constant.dart';
import '../../../../model/game/indoor_game_model.dart';
import '../../../../widgets/snack_bars/error_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';

class QrCratePage extends StatefulWidget {
  const QrCratePage({super.key});

  @override
  State<QrCratePage> createState() => _QrCratePageState();
}

class _QrCratePageState extends State<QrCratePage> {
  static const _checkIcon = Icon(Icons.check_outlined);

  IndoorGameModel _gameModel = IndoorGameModel.empty();
  final TextEditingController _qrInfoTextController = TextEditingController();
  late final Map<String, String> _qrList;
  final TextEditingController _qrNameTextController = TextEditingController();
  final ScreenshotController _screenShootController = ScreenshotController();

  @override
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

  Future<void> saveImage(Uint8List image) async {
    await [Permission.storage].request();
    await ImageGallerySaver.saveImage(image, name: _qrNameTextController.text);
  }

  TextFormField _buildTextFormField(
          TextEditingController controller, String text) =>
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: '$text Giriniz',
          labelText: text,
          suffixIcon: IconButton(
            onPressed: _closeKeyboard,
            icon: _checkIcon,
          ),
        ),
      );

  void _closeKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Screenshot _buildQrImageView() => Screenshot(
        controller: _screenShootController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            QrImageView(
              data: _qrInfoTextController.text,
              size: 200,
              backgroundColor: Colors.white,
            ),
            Text(
              _qrNameTextController.text,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

  Padding _buildBody() => Padding(
        padding: context.paddingNormalSymmetric,
        child: Center(
          child: SingleChildScrollView(
            child: _buildColumn(),
          ),
        ),
      );

  Column _buildColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildQrImageView(),
          const SizedBox(
            height: 60,
          ),
          _buildTextFormField(_qrNameTextController, 'İsim'),
          const SizedBox(
            height: 60,
          ),
          _buildTextFormField(_qrInfoTextController, 'İpucu'),
        ],
      );

  AppBar _buildAppBar() => AppBar(
        title: const Text('Qr Oluştur'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _addQr,
            icon: _checkIcon,
          ),
        ],
      );

  Future<void> _addQr() async {
    var key = _qrNameTextController.text;
    var value = _qrInfoTextController.text;
    if (key.isNotEmpty && value.isNotEmpty) {
      if (_qrList[key] == null) {
        await _screenShoot();
        var data = {key: value};
        _qrList.addAll(data);
        _gameModel.qrList = _qrList;
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.qrList, args: _gameModel); 
      } else {
        _showError('Aynı isimde birden fazla qr eklenemez.');
      }
    } else {
      _showError('İsim veya ipucu boş bırakılamaz.');
    }
  }

  void _showError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  _screenShoot() async {
    final image = await _screenShootController.capture();
    if (image != null) {
      await saveImage(image);
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
