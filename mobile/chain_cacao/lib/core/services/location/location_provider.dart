import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';

/// Provider pour injecter l'interface de localisation (permet le mock en test)
final locationServiceProvider = Provider<ILocationService>((ref) {
  return GeolocatorLocationService();
});
