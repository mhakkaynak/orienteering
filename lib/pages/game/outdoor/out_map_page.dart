import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../../core/constants/navigation/navigation_constant.dart';
import '../../../core/init/navigation/navigation_manager.dart';
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
  String gameTitle = '';
  String? currentGameId;
  late DateTime selectedDateTime;

  late OutMapModel outMapModel;

  @override
  void initState() {
    super.initState();
    currentGameId = null;
    _getLocation();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => _getLocation());
    _outMapModelService = OutMapModelService();
    selectedDateTime = DateTime.now();

    outMapModel = OutMapModel(
      markerAdet: markerAdet,
      id: id,
      gametitle: id, 
      selectedDateTime: selectedDateTime,
      markers: [], 
      joinedPlayers: [],
    );
  }

  void setCurrentGameId(String gameId) {
    setState(() {
      currentGameId = gameId;
      outMapModel = OutMapModel(
        markerAdet: markerAdet,
        id: currentGameId!, 
        selectedDateTime: selectedDateTime,
        markers: [], 
        joinedPlayers: [], 
        gametitle: gameTitle,
      );
    });
  }

  void updateOutMapModel() {
    setState(() {
      outMapModel = OutMapModel(
        markerAdet: markerAdet,
        id: currentGameId!, 
        selectedDateTime: selectedDateTime,
        markers: outMapModel.markers, 
        joinedPlayers: [], 
        gametitle: gameTitle,
      );
    });
  }

  Future<void> _getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
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



  @override
  void dispose() {
    super.dispose();
  }

  void _startGame() async {
    setState(() {
      markerAdet = outMapModel.markerAdet; // markerAdet değerini set ettik
    });
    
    try {
      outMapModel = OutMapModel( // outMapModel nesnesini güncelliyoruz
        markerAdet: markerAdet,
       selectedDateTime: selectedDateTime,
        id: id, 
        markers: [], 
        joinedPlayers: [], gametitle: gameTitle,
      );
      currentGameId = await _outMapModelService.create(outMapModel); 
      print('Veri oluşturuldu: ${outMapModel.toJson()}');
    } catch (e) {
      print('Veri oluşturulurken hata oluştu: $e');
    }
  }


   void _stopGame() async {
 
  updateOutMapModel(); // Burada çağırıyoruz
  try {
    await _outMapModelService.update(outMapModel, currentGameId!); // veri tabanında güncelleme yap
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
  onPressed: () async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      // ignore: use_build_context_synchronously
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime2 = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Save selectedDateTime to outMapModel
        selectedDateTime = selectedDateTime2;

        _stopGame();

        // ignore: use_build_context_synchronously
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: Text('Oyun ismi girin'),
              content: TextField(
                keyboardType: TextInputType.name,
                onChanged: (value) async {
                  gameTitle = value;
                  updateOutMapModel();
                  try {
                    await _outMapModelService.update(outMapModel, currentGameId!);
                    print('Veri güncellendi: ${outMapModel.toJson()}');
                  } catch (e) {
                    print('Veri güncellenirken hata oluştu: $e');
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    NavigationManager.instance.navigationToPage(
                      NavigationConstant.home
                    );
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    }
  },
  icon: const Icon(Icons.save),
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
        
      });

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
    outMapModel.markers.add(GeoPoint(latLng.latitude, latLng.longitude));
  });
}

}
