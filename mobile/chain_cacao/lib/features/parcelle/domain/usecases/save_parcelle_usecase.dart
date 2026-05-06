import 'package:fpdart/fpdart.dart';
import '../entities/parcelle.dart';
import '../repositories/parcelle_repository.dart';

class SaveParcelleUseCase {
  final ParcelleRepository repository;

  SaveParcelleUseCase(this.repository);

  Future<Either<String, Parcelle>> call(Parcelle parcelle) async {
    return await repository.saveParcelle(parcelle);
  }
}
