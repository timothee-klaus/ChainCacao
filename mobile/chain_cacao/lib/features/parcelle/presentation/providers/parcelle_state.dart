import '../../domain/entities/parcelle.dart';

class ParcelleState {
  final bool isLoading;
  final String? error;
  final List<Parcelle> parcelles;
  
  // Recording state
  final bool isRecording;
  final List<ParcelleCoordinate> recordedPath;
  final bool isLocationServiceEnabled;
  final bool hasLocationPermission;

  const ParcelleState({
    this.isLoading = false,
    this.error,
    this.parcelles = const [],
    this.isRecording = false,
    this.recordedPath = const [],
    this.isLocationServiceEnabled = true,
    this.hasLocationPermission = true,
  });

  ParcelleState copyWith({
    bool? isLoading,
    String? error,
    List<Parcelle>? parcelles,
    bool? isRecording,
    List<ParcelleCoordinate>? recordedPath,
    bool? isLocationServiceEnabled,
    bool? hasLocationPermission,
  }) {
    return ParcelleState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      parcelles: parcelles ?? this.parcelles,
      isRecording: isRecording ?? this.isRecording,
      recordedPath: recordedPath ?? this.recordedPath,
      isLocationServiceEnabled: isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      hasLocationPermission: hasLocationPermission ?? this.hasLocationPermission,
    );
  }
}
