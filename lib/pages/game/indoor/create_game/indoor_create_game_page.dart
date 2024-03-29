import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/navigation/navigation_constant.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/init/navigation/navigation_manager.dart';
import '../../../../model/game/indoor_game_model.dart';
import '../../../../widgets/buttons/image_button.dart';
import '../../../../widgets/snack_bars/error_snack_bar.dart';
import '../../../../widgets/text_form_field/date_text_form_field.dart';

class IndoorCraeteGame extends StatefulWidget {
  const IndoorCraeteGame({super.key});

  @override
  State<IndoorCraeteGame> createState() => _IndoorCraeteGameState();
}

class _IndoorCraeteGameState extends State<IndoorCraeteGame> {
  final TextEditingController _dateTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();

  final String _imageErrorText = 'Fotoğraf yüklenemedi.';
  String? _imagePath;
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _rulesTextController = TextEditingController();
  final TextEditingController _titleTextController = TextEditingController();

  Column _buildColumn(BuildContext context) => Column(
        children: [
          _buildAddImageButton(),
          _buildSizedBox(context, height: 0.06),
          _buildTextFormField(_titleTextController, 'Başlık'),
          _buildSizedBox(context),
          _buildTextFormField(_descriptionTextController, 'Açıklama'),
          _buildSizedBox(context),
          _buildTextFormField(_rulesTextController, 'Kural'),
          _buildSizedBox(context),
          _buildTextFormField(_locationTextController, 'Konum'),
          _buildSizedBox(context),
          DateTextFormField(dateController: _dateTextController),
          _buildSizedBox(context, height: 0.1),
          _buildFilledButton(context)
        ],
      );

  FilledButton _buildFilledButton(BuildContext context) => FilledButton(
        onPressed: () {
          _goToQrListPage(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.customWidthValue(0.16),
          ),
          child: const Text('İlerle'),
        ),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: const Text('Indoor Oyun Oluştur'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                _goToQrListPage(context);
              },
              icon: const Icon(Icons.arrow_forward_outlined))
        ],
      );

  TextFormField _buildTextFormField(
          TextEditingController controller, String text) =>
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: '$text Giriniz',
          labelText: text,
        ),
      );

  SizedBox _buildSizedBox(BuildContext context, {double? height}) => SizedBox(
        height: context.customHeightValue(height ?? 0.04),
      );

  void _goToQrListPage(BuildContext context) {
    if (_titleTextController.text.isNotEmpty &&
        _dateTextController.text.isNotEmpty &&
        _descriptionTextController.text.isNotEmpty &&
        _locationTextController.text.isNotEmpty &&
        _rulesTextController.text.isNotEmpty) {
      IndoorGameModel model = IndoorGameModel(
        date: _dateTextController.text,
        description: _descriptionTextController.text,
        imagePath: _imagePath ?? '',
        rules: _rulesTextController.text,
        location: _locationTextController.text,
        title: _titleTextController.text,
      );
      NavigationManager.instance
          .navigationToPage(NavigationConstant.qrList, args: model);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
        context: context,
        text: 'Lütfen bütün alanları doldurunuz.',
      ));
    }
  }

  Padding _buildBody(BuildContext context) => Padding(
        padding: context.paddingNormalSymmetric,
        child: SingleChildScrollView(
          child: _buildColumn(context),
        ),
      );

  Future<void> _addImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg'],
    );
    if (result == null && context.mounted) {
      _showSnackBar(_imageErrorText);
    } else {
      setState(() {
        _imagePath = result!.files.single.path;
      });
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  ImageButton _buildAddImageButton() => ImageButton(
        context: context,
        onTap: _addImage,
        size: context.customHeightValue(0.2),
        imagePath: _imagePath,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
