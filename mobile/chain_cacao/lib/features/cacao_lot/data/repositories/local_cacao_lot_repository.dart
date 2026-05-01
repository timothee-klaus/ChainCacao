import '../../domain/entities/cacao_lot.dart';
import '../../domain/repositories/cacao_lot_repository.dart';

/// Implémentation concrète locale (à connecter à Sqflite ultérieurement)
class LocalCacaoLotRepository implements CacaoLotRepository {
  // Liste en mémoire temporaire pour l'exemple
  final List<CacaoLot> _mockDatabase = [];

  @override
  Future<void> saveLot(CacaoLot lot) async {
    // Simuler un délai d'écriture
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDatabase.add(lot);
  }

  @override
  Future<List<CacaoLot>> getLots() async {
    // Simuler un délai de lecture
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_mockDatabase);
  }
}
