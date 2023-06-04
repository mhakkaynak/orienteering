import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class GameStatisticsPage extends StatefulWidget {
  const GameStatisticsPage({super.key});

  @override
  State<GameStatisticsPage> createState() => _GameStatisticsPageState();
}

class _GameStatisticsPageState extends State<GameStatisticsPage> {
  String _gameTitle = '';
  @override
  void initState() {
    /*var data = ModalRoute.of(context)?.settings.arguments;
    setState(() {
      _gameTitle = data.toString();
    }); */
    // TODO: aç
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oyun Bitti'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.paddingLowSymmetric,
          child: Column(
            children: [
              _buildContainer('Oyuncu Sıralamaları'),
              const SizedBox(height: 30),
              _buildContainer('Oyun Özeti'),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildContainer(String title) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: context.paddingNormalSymmetric,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: context.paddingLowSymmetric,
                    child: Row(
                      children: [
                        Text(
                          'testsdasda:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text('9'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
