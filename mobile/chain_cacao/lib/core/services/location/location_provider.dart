import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'location_service.dart';
import '../media/media_service.dart';

final locationServiceProvider = Provider((ref) => LocationService());
final mediaServiceProvider = Provider((ref) => MediaService());
