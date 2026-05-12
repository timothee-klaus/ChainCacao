import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cacao_lot.dart';
import '../providers/cacao_lot_provider.dart';

class CacaoLotListNotifier extends AsyncNotifier<List<CacaoLot>> {
  @override
  Future<List<CacaoLot>> build() async {
    return _fetchLots();
  }

  Future<List<CacaoLot>> _fetchLots() async {
    final repository = ref.read(cacaoLotRepositoryProvider);
    final result = await repository.getAllLots();
    return result.fold(
      (error) => throw error,
      (lots) => lots..sort((a, b) => b.dateCollecte.compareTo(a.dateCollecte)),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchLots());
  }
}

final cacaoLotListNotifierProvider =
    AsyncNotifierProvider<CacaoLotListNotifier, List<CacaoLot>>(() {
      return CacaoLotListNotifier();
    });
