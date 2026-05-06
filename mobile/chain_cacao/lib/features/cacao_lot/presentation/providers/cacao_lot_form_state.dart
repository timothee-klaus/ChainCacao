
import '../../domain/entities/cacao_lot.dart';

class CacaoLotFormState {
  final bool isLoading;
  final String? error;
  final bool success;
  final CacaoLot? savedLot;
  
  // Données du formulaire
  final String? parcelleId;
  final List<String> photos;
  final double? latitude;
  final double? longitude;
  final bool isLocationCaptured;
  final bool isCapturingLocation;

  CacaoLotFormState({
    this.isLoading = false,
    this.error,
    this.success = false,
    this.savedLot,
    this.parcelleId,
    this.photos = const [],
    this.latitude,
    this.longitude,
    this.isLocationCaptured = false,
    this.isCapturingLocation = false,
  });

  CacaoLotFormState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
    CacaoLot? savedLot,
    String? parcelleId,
    List<String>? photos,
    double? latitude,
    double? longitude,
    bool? isLocationCaptured,
    bool? isCapturingLocation,
  }) {
    return CacaoLotFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
      savedLot: savedLot ?? this.savedLot,
      parcelleId: parcelleId ?? this.parcelleId,
      photos: photos ?? this.photos,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLocationCaptured: isLocationCaptured ?? this.isLocationCaptured,
      isCapturingLocation: isCapturingLocation ?? this.isCapturingLocation,
    );
  }
}
