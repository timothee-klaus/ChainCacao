import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/repositories/cacao_lot_repository_impl.dart';
import '../../domain/repositories/cacao_lot_repository.dart';
import '../../domain/usecases/save_cacao_lot_usecase.dart';
import '../../domain/entities/cacao_lot.dart';

final cacaoLotRepositoryProvider = Provider<CacaoLotRepository>((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return CacaoLotRepositoryImpl(isarService);
});

final saveCacaoLotUseCaseProvider = Provider<SaveCacaoLotUseCase>((ref) {
  final repository = ref.watch(cacaoLotRepositoryProvider);
  return SaveCacaoLotUseCase(repository);
});

/// State pour la gestion de l'UI
class CacaoLotState {
  final bool isLoading;
  final String? error;
  final bool success;

  CacaoLotState({this.isLoading = false, this.error, this.success = false});

  CacaoLotState copyWith({bool? isLoading, String? error, bool? success}) {
    return CacaoLotState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }
}

class CacaoLotNotifier extends StateNotifier<CacaoLotState> {
  final SaveCacaoLotUseCase saveCacaoLotUseCase;

  CacaoLotNotifier(this.saveCacaoLotUseCase) : super(CacaoLotState());

  Future<void> saveLot(CacaoLot lot) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    
    final result = await saveCacaoLotUseCase(lot);
    
    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (lot) => state = state.copyWith(isLoading: false, success: true),
    );
  }
}

final cacaoLotControllerProvider = StateNotifierProvider<CacaoLotNotifier, CacaoLotState>((ref) {
  final saveUseCase = ref.watch(saveCacaoLotUseCaseProvider);
  return CacaoLotNotifier(saveUseCase);
});
