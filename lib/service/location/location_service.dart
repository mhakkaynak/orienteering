import '../../core/init/firebase/firestore_manager.dart';

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

  Future<List<String>> getCities() async {
    try {
      Map<String, dynamic> cities = {};
      cities = await _firestoreManager.get('city') as Map<String, dynamic>;
      List<String> cityList = [];
      for (var i = 0; i < cities.length; i++) {
        cityList.add(cities[(i + 1).toString()] ?? 'Kocaeli');
      }
      return cityList;
    } catch (e) {
      return [];
    }
  }

  Future<String> getCityWithLicensePlate(int licensePlate) async {
    try {
      var cities = await getCities();
      return cities[licensePlate - 1];
    } catch (e) {
      return 'Kocaeli';
    }
  }
}
