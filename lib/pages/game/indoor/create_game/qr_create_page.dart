import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/extensions/context_extension.dart';

class QrCratePage extends StatefulWidget {
  const QrCratePage({super.key});

  @override
  State<QrCratePage> createState() => _QrCratePageState();
}

class _QrCratePageState extends State<QrCratePage> {
  static const _checkIcon = Icon(Icons.check_outlined);

  final TextEditingController _controller = TextEditingController();

  TextFormField _buildTextFormField() => TextFormField(
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
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
        data: _controller.text,
        size: 200,
        backgroundColor: Colors.white,
      );

  Padding _buildBody(BuildContext context) => Padding(
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
          _buildTextFormField(),
        ],
      );

  AppBar _buildAppBar() => AppBar(
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

  // TODO: database' e kayıt islemleri yapılacak!
  void _addQr() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }
}
