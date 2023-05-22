import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

import '../../../model/game/outdoor_game_model.dart';
import '../../../service/game/outdoor/outdoor_game_service.dart';

class OutMapPage extends StatefulWidget {
  const OutMapPage({Key? key}) : super(key: key);

  @override
  State<OutMapPage> createState() => OutMapPageState();
}

class OutMapPageState extends State<OutMapPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();
  LocationData? _currentLocation;
  late OutMapModelService _outMapModelService;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};
  int markerCount = 0;
  int markerAdet = 0;
  int score = 0;
  bool isTimerRunning = false;
  int secondsPassed = 0;
  String id = "";
  late Timer _timer;

  late OutMapModel outMapModel;

  @override
  void initState() {
    super.initState();
    _getLocation();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => _getLocation());
    _outMapModelService = OutMapModelService();

    outMapModel = OutMapModel(
      markerAdet: markerAdet,
      score: score,
      secondsPassed: secondsPassed,
      id: id,
    );
  }

  Future<void> _getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
        _checkIfReachedMarker();
      });

      if (!isTimerRunning && _markers.length == outMapModel.markerAdet) {
        _startTimer();
      }

      if (_markers.length == 0) {
        _stopTimer();
      }
    } catch (e) {
      print('Could not get location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location data could not be retrieved.'),
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

  void _increaseScore() {
    setState(() {
      outMapModel.score += 50;
    });
  }

  void _startTimer() {
    if (!isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        setState(() {
          outMapModel.secondsPassed++;
        });
      });
      isTimerRunning = true;
    }
  }

  void _stopTimer() {
    _timer.cancel();
    isTimerRunning = false;
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

  void _startGame() async {
    setState(() {
      isTimerRunning = true;
      outMapModel.secondsPassed = 0;
      outMapModel.score = 0;
    });
    _startTimer();
    try {
      await _outMapModelService.create(outMapModel);
      print('Veri oluşturuldu: ${outMapModel.toJson()}');
    } catch (e) {
      print('Veri oluşturulurken hata oluştu: $e');
    }
  }

  void _stopGame() async {
    setState(() {
      isTimerRunning = false;
    });
    _stopTimer();
    try {
      await _outMapModelService.update(outMapModel, "x6jjBYaGKvBFMAkT0eVq");
      print('Veri güncellendi: ${outMapModel.toJson()}');
    } catch (e) {
      print('Veri güncellenirken hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Kaç marker eklemek istersin?'),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      outMapModel.markerAdet = int.parse(value);
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _startGame();
                      },
                      child: Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.accessibility_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _stopGame();
            },
            icon: Icon(Icons.stop),
          ),
        ],
      ),
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
              myLocationButtonEnabled: true,
              markers: _markers,
              onLongPress: (LatLng latLng) {
                if (outMapModel.markerAdet != markerCount) {
                  _addMarkersPrompt(latLng);
                }
              },
            ),
          ),
          Visibility(
            visible: isTimerRunning,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Süre: ${_formatDuration(outMapModel.secondsPassed)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Puan: ${outMapModel.score}',
              style: TextStyle(fontSize: 16),
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

      CameraPosition newPosition = CameraPosition(
        target: LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
        zoom: 17.0,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    });
  }

  void _addMarkersPrompt(LatLng latLng) {
    showDialog(
      context: context,
      builder: (context) {
        String markerName = '';
        return AlertDialog(
          title: Text('${_markers.length + 1}. marker ismi'),
          content: TextField(
            onChanged: (value) {
              markerName = value;
            },
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (outMapModel.markerAdet != markerCount) {
                  markerCount++;
                  Navigator.of(context).pop();
                  _addMarkers(latLng, markerCount, markerCount);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _addMarkers(LatLng latLng, int markersToAdd, int markerCount) {
    Set<Marker> newMarkers = {};
    for (int i = 0; i < markersToAdd; i++) {
      Marker marker = Marker(
        markerId: MarkerId('marker_${_markers.length + 1}'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Marker ${_markers.length + 1}',
        ),
      );
      newMarkers.add(marker);
    }
    setState(() {
      _markers.addAll(newMarkers);
    });
  }
}
