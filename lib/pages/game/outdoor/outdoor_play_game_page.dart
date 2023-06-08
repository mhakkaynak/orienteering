import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;
import '../../../model/game/outdoor_game_model.dart';
import '../../../service/game/outdoor/outdoor_game_service.dart';

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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  int markerCount = 0;
  int markerAdet = 0;
  int playerCount = 0;
  int score = 0;
  bool isTimerRunning = false;
  int secondsPassed = 0;
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
  }
Future<void> _getMarkersFromFirebase() async {
    try {
      OutMapModel outMapModel = await OutMapModelService.get("fRtR5gGJvcvWO4prKyhc");
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
        print("marker: $markerAdet and oyuncu sayısı: $playerCount ve $markers");
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

void _stopTimer() {
    _timer.cancel();
    isTimerRunning = false;
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
    return Scaffold(appBar: AppBar(title: Text("Kayıtlı Oyuncu: $playerCount", style: const TextStyle(fontSize: 24),),),
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
