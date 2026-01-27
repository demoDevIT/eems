import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' hide LocationAccuracy;
class LocationService {

  static final Location _location = Location();


static Future<bool> isLocationServiceEnabled() async {
    bool serviceEnabled = await _location.serviceEnabled();
    while (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
      }
    }
    return true;
  }


  static Future<LocationPermission> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
    }
    return permission;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      if (!await isLocationServiceEnabled()) {
        return null;
      }

      LocationPermission permission = await requestLocationPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Current Location: Lat: ${position.latitude}, Lon: ${position.longitude}");
      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }


}




