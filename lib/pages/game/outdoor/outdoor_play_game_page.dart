import 'dart:async';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../model/game/outdoor_game_model.dart';
import '../../../model/game/outdoor_statistics_model.dart';
import '../../../service/game/outdoor/outdoor_game_service.dart';
import '../../../service/game/outdoor/outdoor_statistics_service.dart';
import '../../home/subpages/home_subpage.dart';

class OutdoorPlayGame extends StatefulWidget {
  const OutdoorPlayGame({Key? key}) : super(key: key);

  @override
  State<OutdoorPlayGame> createState() => OutdoorPlayGameState();
}

class OutdoorPlayGameState extends State<OutdoorPlayGame> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();
  LocationData? _currentLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.7999, 29.9552),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  int markerCount = 0;
  int markerAdet = 0;
  int playerCount = 0;
  int score = 0;
  bool isTimerRunning = false;
  int secondsPassed = 0;
  String gameTitle = '';
  String? currentGameId;
  late Timer _timer;

  

  @override
  void initState() {
    super.initState();
    currentGameId = null;
    _getLocation();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => _getLocation());
    _getMarkersFromFirebase();
    _startTimer();
    checkUserPerformance();
  }
  
Future<void> _getMarkersFromFirebase() async {
    try {
      OutMapModel outMapModel = await OutMapModelService.get(HomeSubpage.gameId.toString());
      List<Marker> markers = [];
      
      for (var marker in outMapModel.markers) {
        Marker googleMapMarker = Marker(
          markerId: MarkerId(marker.latitude.toString()),
          position: LatLng(marker.latitude, marker.longitude),
          infoWindow: InfoWindow(title: marker.latitude.toString()),
        );
        markers.add(googleMapMarker);
      }
      setState(() {
        _markers.addAll(markers);
        markerAdet = outMapModel.markerAdet;
        playerCount = outMapModel.joinedPlayers.length;
        gameTitle = outMapModel.gametitle;
        
      });
    } catch (e) {
      print('Veriler çekilirken hata oluştu: $e');
    }
  }
  
  Future<void> _getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
        _checkIfReachedMarker();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasyon bilgileri sağlanamadı.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _checkIfReachedMarker() {
    if (_currentLocation != null) {
      double userLat = _currentLocation!.latitude!;
      double userLng = _currentLocation!.longitude!;
      Set<Marker> reachedMarkers = {};
      for (Marker marker in _markers) {
        double markerLat = marker.position.latitude;
        double markerLng = marker.position.longitude;
        double distance = _calculateDistance(userLat, userLng, markerLat, markerLng);
        if (distance <= 50) {
          reachedMarkers.add(marker);
          _showReachedMarkerSnackbar();
          _increaseScore();
        }
      }
      setState(() {
        _markers.removeAll(reachedMarkers);
      });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371000; // in meters
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degree) {
    return degree * (math.pi / 180);
  }

  void _showReachedMarkerSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tebrikler, seçtiğiniz markera ulaştınız!'),
      ),
    );
  }

  void _increaseScore() async {
  setState(() {
    score += 50;
    markerCount++;
    if(markerAdet == markerCount) {
        _stopTimer();
        showDialog(context: context, builder: (context){
          return AlertDialog(
          title: Text('Puanınız: $score \nSüreniz: $secondsPassed'),
          
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tamam'),
            ),
          ],
        );
        },);
    }
  });
}

void checkUserPerformance() async {
  String userId = "user123";
  String gameId = "game123";
  
  List<PlayerStats>? stats = await PlayerStatsService().getPlayerStats(userId, gameId);
  
  if (stats.isNotEmpty) {
    print("Score in the last game: ${stats.last.score}");
  }
}

void _stopTimer() async {
    _timer.cancel();
    isTimerRunning = false;
 String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId != null) {
    PlayerStats stats = PlayerStats(userId: currentUserId, score: score, secondsPassed: secondsPassed);
    PlayerStatsService().updatePlayerStats(gameTitle, stats);
  }
  }

  void _startTimer() {
    if (!isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          secondsPassed++;
        });
      });
      isTimerRunning = true;
    }
  }

  String _formatDuration(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String formattedDuration = '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return formattedDuration;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Kayıtlı Oyuncu Sayısı: $playerCount", style: const TextStyle(fontSize: 24,),),),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _animateToUser();
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapToolbarEnabled: false,
              markers: _markers,
            ),
          ),
          Visibility(
            visible: isTimerRunning,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Süre: ${_formatDuration(secondsPassed)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Puan: $score',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _animateToUser() async {
    final GoogleMapController controller = await _controller.future;
    LocationData pos = await Location().getLocation();
    CameraPosition newPos = CameraPosition(
      target: LatLng(pos.latitude ?? 0, pos.longitude ?? 0),
      zoom: 17.0,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
    _location.onLocationChanged.listen((LocationData currentLocation) {
      print('Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
      setState(() {
        _currentLocation = currentLocation;
        _checkIfReachedMarker();
      });
    });
  }

}
