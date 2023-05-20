import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/widgets/snack_bars/error_snack_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';

class QrCratePage extends StatefulWidget {
  const QrCratePage({super.key});

  @override
  State<QrCratePage> createState() => _QrCratePageState();
}

class _QrCratePageState extends State<QrCratePage> {
  static const _checkIcon = Icon(Icons.check_outlined);

  final TextEditingController _qrInfoTextController = TextEditingController();
  late final Map<String, String> _qrList;
  final TextEditingController _qrNameTextController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var data =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      _qrList = data;
    });
    super.initState();
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

  QrImageView _buildQrImageView() => QrImageView(
        data: _qrInfoTextController.text,
        size: 200,
        backgroundColor: Colors.white,
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
        title: Text('Qr Oluştur'),
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

  void _addQr() {
    var key = _qrNameTextController.text;
    var value = _qrInfoTextController.text;
    if (key.isNotEmpty && value.isNotEmpty) {
      if (_qrList[key] == null) {
        var data = {key: value};
        _qrList.addAll(data);
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.qrList, args: _qrList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }
}
