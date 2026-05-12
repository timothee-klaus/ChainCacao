import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await isServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
