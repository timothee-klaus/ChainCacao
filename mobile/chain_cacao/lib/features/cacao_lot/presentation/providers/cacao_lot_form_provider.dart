import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location/location_provider.dart';
import '../../../../core/services/location/location_service.dart';
import '../../../../core/services/media/media_service.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/usecases/save_cacao_lot_usecase.dart';
import '../providers/cacao_lot_provider.dart';
import 'cacao_lot_form_state.dart';
import 'cacao_lot_list_provider.dart';

class CacaoLotFormNotifier extends StateNotifier<CacaoLotFormState> {
  final SaveCacaoLotUseCase _saveUseCase;
  final LocationService _locationService;
  final MediaService _mediaService;
  final Ref ref;

  CacaoLotFormNotifier({
    required SaveCacaoLotUseCase saveUseCase,
    required LocationService locationService,
    required MediaService mediaService,
    required this.ref,
  }) : _saveUseCase = saveUseCase,
       _locationService = locationService,
       _mediaService = mediaService,
       super(CacaoLotFormState());

  Future<void> captureLocation() async {
    state = state.copyWith(isCapturingLocation: true, error: null);
    final position = await _locationService.getCurrentPosition();

    if (position != null) {
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        isLocationCaptured: true,
        isCapturingLocation: false,
      );
    } else {
      state = state.copyWith(
        isCapturingLocation: false,
        error:
            'Impossible de récupérer la position GPS. Vérifiez vos permissions.',
      );
    }
  }

  Future<void> takePhoto() async {
    final path = await _mediaService.capturePhoto();
    if (path != null) {
      state = state.copyWith(photos: [...state.photos, path]);
    }
  }

  void removePhoto(int index) {
    final newPhotos = List<String>.from(state.photos)..removeAt(index);
    state = state.copyWith(photos: newPhotos);
  }

  void setParcelleId(String? id) {
    state = state.copyWith(parcelleId: id);
  }

  Future<void> submitLot(CacaoLot lot) async {
    state = state.copyWith(isLoading: true, error: null, success: false);

    // On injecte les données gérées par le controller (GPS, Photos) dans l'entité
    final finalLot = lot.copyWith(
      latitude: state.latitude,
      longitude: state.longitude,
      photoUrls: state.photos,
      parcelleId: state.parcelleId,
    );

    final result = await _saveUseCase(finalLot);

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (successLot) {
        state = state.copyWith(
          isLoading: false,
          success: true,
          savedLot: successLot,
        );
        // On rafraîchit la liste des lots automatiquement
        ref.invalidate(cacaoLotListNotifierProvider);
      },
    );
  }
}

final cacaoLotFormNotifierProvider =
    StateNotifierProvider.autoDispose<CacaoLotFormNotifier, CacaoLotFormState>((
      ref,
    ) {
      return CacaoLotFormNotifier(
        saveUseCase: ref.watch(saveCacaoLotUseCaseProvider),
        locationService: ref.watch(locationServiceProvider),
        mediaService: ref.watch(mediaServiceProvider),
        ref: ref,
      );
    });
