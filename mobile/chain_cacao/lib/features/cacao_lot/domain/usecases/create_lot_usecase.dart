import 'package:fpdart/fpdart.dart';
import '../entities/cacao_lot.dart';
import '../repositories/cacao_lot_repository.dart';

class CreateLotUseCase {
  final CacaoLotRepository repository;

  CreateLotUseCase(this.repository);

  Future<Either<String, void>> call(CacaoLot lot) async {
    // Logique métier : validation des données du lot
    if (lot.weightKg <= 0) {
      return left('Le poids du lot doit être strictement positif.');
    }
    if (lot.species.isEmpty) {
      return left('L\'espèce de cacao est requise.');
    }
    if (lot.farmerId.isEmpty) {
      return left('L\'identifiant de l\'agriculteur est requis.');
    }
    
    return await repository.saveLot(lot);
  }
}
