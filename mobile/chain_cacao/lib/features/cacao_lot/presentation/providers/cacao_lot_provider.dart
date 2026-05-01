import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/datasources/cacao_lot_local_data_source.dart';
import '../../data/repositories/cacao_lot_repository_impl.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/usecases/create_lot_usecase.dart';
import '../../domain/usecases/get_lots_usecase.dart';

/// Providers pour l'injection de dépendances et la gestion d'état UI

// Source de données locale
final cacaoLotLocalDataSourceProvider = Provider<CacaoLotLocalDataSource>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return CacaoLotLocalDataSourceImpl(isarService);
});

// Repository (exposé par son implémentation pour Riverpod, mais utilisé via son interface)
final cacaoLotRepositoryProvider = Provider<CacaoLotRepositoryImpl>((ref) {
  final localDataSource = ref.watch(cacaoLotLocalDataSourceProvider);
  return CacaoLotRepositoryImpl(localDataSource);
});

// Use Cases
final createLotUseCaseProvider = Provider<CreateLotUseCase>((ref) {
  final repository = ref.watch(cacaoLotRepositoryProvider);
  return CreateLotUseCase(repository);
});

final getLotsUseCaseProvider = Provider<GetLotsUseCase>((ref) {
  final repository = ref.watch(cacaoLotRepositoryProvider);
  return GetLotsUseCase(repository);
});

/// État de la liste des lots
class CacaoLotListController extends AsyncNotifier<List<CacaoLot>> {
  @override
  Future<List<CacaoLot>> build() async {
    final getLotsUseCase = ref.watch(getLotsUseCaseProvider);
    final result = await getLotsUseCase();
    
    return result.fold(
      (error) => throw Exception(error),
      (lots) => lots,
    );
  }

  /// Création d'un lot via le Use Case
  Future<void> addLot(CacaoLot lot) async {
    state = const AsyncLoading();
    
    final createLotUseCase = ref.read(createLotUseCaseProvider);
    final result = await createLotUseCase(lot);
    
    result.fold(
      (error) => state = AsyncError(error, StackTrace.current),
      (_) async {
        // Rafraîchissement de la liste locale après succès
        state = await AsyncValue.guard(() async {
          final getLotsUseCase = ref.read(getLotsUseCaseProvider);
          final fetchResult = await getLotsUseCase();
          return fetchResult.fold((e) => throw Exception(e), (l) => l);
        });
      },
    );
  }
}

// Global Controller Provider
final cacaoLotListProvider = AsyncNotifierProvider<CacaoLotListController, List<CacaoLot>>(() {
  return CacaoLotListController();
});
