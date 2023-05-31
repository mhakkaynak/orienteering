import 'package:flutter/material.dart';

import '../../../core/extensions/context_extension.dart';
import '../../../widgets/card/game_card.dart';
import '../../../widgets/text_form_field/search_text_form_field.dart';

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
      shadowColor: Colors.transparent,
      elevation: 0.0,
      title: SearchTextFormField(
          controller: _searchTextController,
          cancelPressed: () {
            setState(() {
              _searchTextController.text = '';
            });
          }),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: context.paddingLowSymmetric,
      child: Column(
        children: [
          const Divider(),
          Expanded(
            child: Padding(
              padding: context.paddingLowSymmetric,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCard();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  GameCard _buildCard() => GameCard(
      context: context,
      imagePath:
          'https://firebasestorage.googleapis.com/v0/b/orienteering-c1ddc.appspot.com/o/indoorGame%2Ftest?alt=media&token=2b139ebe-7526-446d-8515-93cf755e5ed7&_gl=1*1xvx6a1*_ga*MzczMzY1NDE2LjE2ODA5NTQ1MzA.*_ga_CW55HF8NVT*MTY4NTU2OTYxOS4xNy4xLjE2ODU1Njk2MjcuMC4wLjA.',
      title: 'Title',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      location: 'Bursa',
      date: '10.08.2023');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }
}
