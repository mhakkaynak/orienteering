import 'package:flutter/material.dart';
import '../../../model/game/outdoor_statistics_model.dart';
import '../../../service/game/outdoor/outdoor_statistics_service.dart';

class PlayerStatsPage extends StatefulWidget {
  final String userId;
  final List<String> gameIds; // Add this line to receive list of gameIds from parent widget

  const PlayerStatsPage({super.key, required this.userId, required this.gameIds});

  @override
  _PlayerStatsPageState createState() => _PlayerStatsPageState();
}

class _PlayerStatsPageState extends State<PlayerStatsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Stats'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: widget.gameIds.length,
        itemBuilder: (context, index) {
          return FutureBuilder<List<PlayerStats>>(
            future: PlayerStatsService().getPlayerStats(widget.userId, widget.gameIds[index]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, statsIndex) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Material(
                        color: Colors.brown[100],
                        elevation: 10,
                        borderRadius: BorderRadius.circular(15.0),
                        shadowColor: Colors.greenAccent,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Oyun Adı: ${widget.gameIds[index]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.green[800],
                                ),
                              ),
                              Divider(
                                color: Colors.green[600],
                                thickness: 2,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Skor: ${snapshot.data![statsIndex].score}',
                                style: TextStyle(fontSize: 20, color: Colors.brown[800]),
                              ),
                              Text(
                                'Süre: ${snapshot.data![statsIndex].secondsPassed}',
                                style: TextStyle(fontSize: 20, color: Colors.brown[800]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
