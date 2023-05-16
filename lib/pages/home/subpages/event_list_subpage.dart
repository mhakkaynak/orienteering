import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/widgets/text_form_field/search_text_form_field.dart';

// TODO: etkinlik datası için fonksiyon yazıldığında burası tamamlanacak.
class EventListSubpage extends StatefulWidget {
  const EventListSubpage({super.key});

  @override
  State<EventListSubpage> createState() => _EventListSubpageState();
}

class _EventListSubpageState extends State<EventListSubpage> {
  final TextEditingController _searchTextController = TextEditingController();

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
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
