import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/location/location_provider.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/repositories/cacao_lot_repository.dart';

/// Controller responsable de la gestion d'état des lots de cacao
class CacaoLotController extends AsyncNotifier<List<CacaoLot>> {
  late final CacaoLotRepository _repository;

  @override
  FutureOr<List<CacaoLot>> build() async {
    _repository = ref.read(cacaoLotRepositoryProvider);
    return _repository.getLots();
  }

  /// Crée un nouveau lot localement et l'ajoute à la file de synchro
  Future<void> createLot({
    required String farmerId,
    required String region,
    required double weightKg,
    required String species,
    required DateTime dateCollecte,
    required String coopName,
    required String createdBy,
  }) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final locationService = ref.read(locationServiceProvider);
      
      double? lat;
      double? lng;

      try {
        final position = await locationService.getCurrentPosition();
        lat = position.latitude;
        lng = position.longitude;
      } catch (e) {
        print("Avertissement GPS: $e");
      }

      final newLot = CacaoLot.create(
        lotId: 'LOT-${DateTime.now().millisecondsSinceEpoch}', // ID temporaire
        farmerId: farmerId,
        region: region,
        weightKg: weightKg,
        species: species,
        dateCollecte: dateCollecte,
        coopName: coopName,
        createdBy: createdBy,
        latitude: lat,
        longitude: lng,
      );

      // Sauvegarde Isar + QueueItem
      await _repository.saveLot(newLot);

      // On rafraîchit la liste locale
      return _repository.getLots();
    });
  }
}

/// Provider du controller
final cacaoLotControllerProvider =
    AsyncNotifierProvider<CacaoLotController, List<CacaoLot>>(
  () => CacaoLotController(),
);
