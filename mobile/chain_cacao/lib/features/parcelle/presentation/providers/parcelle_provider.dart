import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/datasources/parcelle_local_data_source.dart';
import '../../data/repositories/parcelle_repository_impl.dart';
import '../../domain/entities/parcelle.dart';
import '../../domain/usecases/get_parcelles_usecase.dart';
import '../../domain/usecases/save_parcelle_usecase.dart';
import 'parcelle_state.dart';

// Data Source Provider
final parcelleLocalDataSourceProvider = FutureProvider((ref) async {
  final isarService = ref.watch(isarServiceProvider);
  final isar = await isarService.db;
  return ParcelleLocalDataSourceImpl(isar);
});

final parcelleNotifierProvider =
    StateNotifierProvider<ParcelleNotifier, ParcelleState>((ref) {
      final dataSource = ref.watch(parcelleLocalDataSourceProvider).value;
      if (dataSource == null) return ParcelleNotifier(null, null);

      final repository = ParcelleRepositoryImpl(dataSource);
      return ParcelleNotifier(
        GetParcellesUseCase(repository),
        SaveParcelleUseCase(repository),
      );
    });

class ParcelleNotifier extends StateNotifier<ParcelleState> {
  final GetParcellesUseCase? _getParcelles;
  final SaveParcelleUseCase? _saveParcelle;
  StreamSubscription<Position>? _positionSubscription;

  ParcelleNotifier(this._getParcelles, this._saveParcelle)
    : super(const ParcelleState()) {
    if (_getParcelles != null) {
      loadParcelles();
    }
  }

  Future<void> loadParcelles() async {
    final getParcelles = _getParcelles;
    if (getParcelles == null) return;
    state = state.copyWith(isLoading: true);
    final result = await getParcelles.call();
    result.fold(
      (l) => state = state.copyWith(isLoading: false, error: l),
      (r) => state = state.copyWith(isLoading: false, parcelles: r),
    );
  }

  Future<void> startRecording() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(isLocationServiceEnabled: false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(hasLocationPermission: false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(hasLocationPermission: false);
      return;
    }

    state = state.copyWith(isRecording: true, recordedPath: []);

    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter:
                0, // Update more frequently for smooth movement and heading
          ),
        ).listen((Position position) {
          final newCoord = ParcelleCoordinate(
            latitude: position.latitude,
            longitude: position.longitude,
          );

          // Update real-time position and heading
          state = state.copyWith(
            currentLocation: newCoord,
            heading: position.heading,
          );

          // Update path only if recording is active and we moved enough
          // We'll use a manual distance check since we set distanceFilter to 0 for smoothness
          if (state.isRecording) {
            if (state.recordedPath.isEmpty) {
              state = state.copyWith(
                recordedPath: [...state.recordedPath, newCoord],
              );
            } else {
              final lastPoint = state.recordedPath.last;
              final distance = Geolocator.distanceBetween(
                lastPoint.latitude,
                lastPoint.longitude,
                newCoord.latitude,
                newCoord.longitude,
              );

              if (distance >= 2.0) {
                // Every 2 meters
                state = state.copyWith(
                  recordedPath: [...state.recordedPath, newCoord],
                );
              }
            }
          }
        });
  }

  Future<void> stopRecording() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    state = state.copyWith(isRecording: false);
  }

  Future<void> saveParcelle(
    String name,
    String ownerName,
    String? description,
  ) async {
    final saveParcelle = _saveParcelle;
    if (saveParcelle == null || state.recordedPath.length < 3) {
      state = state.copyWith(
        error: 'Il faut au moins 3 points pour définir une parcelle',
      );
      return;
    }

    state = state.copyWith(isLoading: true);

    final area = _calculateArea(state.recordedPath);

    final parcelle = Parcelle(
      id: const Uuid().v4(),
      name: name,
      ownerName: ownerName,
      area: area,
      polygon: state.recordedPath,
      createdAt: DateTime.now(),
      description: description,
    );

    final result = await saveParcelle.call(parcelle);
    result.fold((l) => state = state.copyWith(isLoading: false, error: l), (r) {
      state = state.copyWith(
        isLoading: false,
        parcelles: [...state.parcelles, r],
        recordedPath: [],
      );
    });
  }

  double _calculateArea(List<ParcelleCoordinate> path) {
    if (path.length < 3) return 0.0;

    double area = 0.0;
    const double radius = 6378137.0; // WGS84 radius

    for (int i = 0; i < path.length; i++) {
      final p1 = path[i];
      final p2 = path[(i + 1) % path.length];

      area +=
          _toRadians(p2.longitude - p1.longitude) *
          (2 +
              math.sin(_toRadians(p1.latitude)) +
              math.sin(_toRadians(p2.latitude)));
    }

    area = area * radius * radius / 2.0;
    return (area.abs() / 10000.0); // Convert m2 to hectares
  }

  double _toRadians(double degree) => degree * math.pi / 180.0;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
