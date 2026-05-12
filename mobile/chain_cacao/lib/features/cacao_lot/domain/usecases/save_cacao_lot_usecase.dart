import 'package:fpdart/fpdart.dart';
import '../entities/cacao_lot.dart';
import '../repositories/cacao_lot_repository.dart';

class SaveCacaoLotUseCase {
  final CacaoLotRepository repository;

  SaveCacaoLotUseCase(this.repository);

  Future<Either<String, CacaoLot>> call(CacaoLot lot) async {
    // On pourrait ajouter ici des validations métier
    // ex: poids minimum, photos obligatoires, etc.
    if (lot.weightKg <= 0) {
      return left('Le poids du lot doit être supérieur à 0 kg.');
    }

    return await repository.saveLot(lot);
  }
}
