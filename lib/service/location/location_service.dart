import 'package:orienteering/core/init/firebase/firestore_manager.dart';

class LocationService {
  LocationService._init() {
    _firestoreManager = FirestoreManager('state');
  }

  static LocationService? _instance;

  late final FirestoreManager _firestoreManager;

  static LocationService get instance {
    _instance ??= LocationService._init();
    return _instance!;
  }

  Future<Map<String, dynamic>> getCities() async {
    Map<String, dynamic> cities = {};
    cities = await _firestoreManager.get('city') as Map<String, dynamic>;
    return cities;
  }

  Future<String> getCityWithLicensePlate(int licensePlate) async {
    try {
      var cities = await getCities();
      return cities[licensePlate.toString()];
    } catch (e) {
      return 'Kocaeli';
    }
  }
}
