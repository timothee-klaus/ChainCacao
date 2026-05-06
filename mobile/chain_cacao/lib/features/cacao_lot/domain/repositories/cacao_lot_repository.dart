import 'package:fpdart/fpdart.dart';
import '../entities/cacao_lot.dart';

abstract class CacaoLotRepository {
  /// Enregistre un nouveau lot localement
  Future<Either<String, CacaoLot>> saveLot(CacaoLot lot);

  /// Récupère tous les lots (locaux)
  Future<Either<String, List<CacaoLot>>> getAllLots();

  /// Récupère les lots en attente de synchronisation
  Future<Either<String, List<CacaoLot>>> getPendingLots();

  /// Marque un lot comme synchronisé
  Future<Either<String, Unit>> markAsSynced(String lotId, String txHash);
}
