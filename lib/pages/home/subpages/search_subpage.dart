import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/widgets/text_form_field/search_text_form_field.dart';
// TODO: etkinlik datası için fonksiyon yazıldığında burası tamamlanacak.
class SearchSubPage extends StatefulWidget {
  const SearchSubPage({super.key});

  @override
  State<SearchSubPage> createState() => _SearchSubPageState();
}

class _SearchSubPageState extends State<SearchSubPage> {
  static const Color _backgroundColor = Color(0XFFECFEE0);

  final TextEditingController _searchTextController = TextEditingController();

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _backgroundColor,
      title: SearchTextFormField(
          controller: _searchTextController,
          cancelPressed: () {
            setState(() {
              _searchTextController.text = '';
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: Padding(
              padding: context.paddingLowSymmetric,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Text('test');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
