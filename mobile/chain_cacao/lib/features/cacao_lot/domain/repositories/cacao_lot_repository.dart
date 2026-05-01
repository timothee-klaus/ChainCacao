import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/repositories/isar_cacao_lot_repository.dart';
import '../entities/cacao_lot.dart';

/// Contrat pour le stockage des lots de cacao
abstract class CacaoLotRepository {
  Future<void> saveLot(CacaoLot lot);
  Future<List<CacaoLot>> getLots();
}

/// Provider pour le repository utilisant Isar
final cacaoLotRepositoryProvider = Provider<CacaoLotRepository>((ref) {
  final isarService = ref.read(isarServiceProvider);
  return IsarCacaoLotRepository(isarService);
});
