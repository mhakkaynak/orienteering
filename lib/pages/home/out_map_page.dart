import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OutMapPage extends StatefulWidget {
  const OutMapPage({Key? key}) : super(key: key);

  @override
  State<OutMapPage> createState() => OutMapPageState();
}

class OutMapPageState extends State<OutMapPage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Location _location = Location();
  LocationData? _currentLocation;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _getLocation();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => _getLocation());
  }

  Future<void> _getLocation() async {
    try {
      final LocationData locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
      });
    } catch (e) {
      print('Could not get location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _animateToUser();
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
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

      CameraPosition newPosition = CameraPosition(
        target: LatLng(currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
        zoom: 17.0,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    });
  }
}
