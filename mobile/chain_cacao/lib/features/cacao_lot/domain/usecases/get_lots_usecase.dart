import 'package:fpdart/fpdart.dart';
import '../entities/cacao_lot.dart';
import '../repositories/cacao_lot_repository.dart';

class GetLotsUseCase {
  final CacaoLotRepository repository;

  GetLotsUseCase(this.repository);

  Future<Either<String, List<CacaoLot>>> call() async {
    return await repository.getAllLots();
  }
}
