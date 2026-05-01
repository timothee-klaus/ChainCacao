import 'package:fpdart/fpdart.dart';
import '../entities/cacao_lot.dart';

/// Contrat pour la gestion des lots de cacao.
abstract class CacaoLotRepository {
  Future<Either<String, void>> saveLot(CacaoLot lot);
  Future<Either<String, List<CacaoLot>>> getLots();
}
