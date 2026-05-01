import 'package:geolocator/geolocator.dart';

/// Interface abstraite pour le service de localisation
abstract class ILocationService {
  Future<Position> getCurrentPosition();
}

/// Implémentation concrète utilisant le package geolocator
class GeolocatorLocationService implements ILocationService {
  @override
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Les services de localisation sont désactivés.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Les permissions de localisation sont refusées.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Les permissions de localisation sont définitivement refusées.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
