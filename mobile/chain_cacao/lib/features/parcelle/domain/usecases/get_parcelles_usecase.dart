import 'package:fpdart/fpdart.dart';
import '../entities/parcelle.dart';
import '../repositories/parcelle_repository.dart';

class GetParcellesUseCase {
  final ParcelleRepository repository;

  GetParcellesUseCase(this.repository);

  Future<Either<String, List<Parcelle>>> call() async {
    return await repository.getParcelles();
  }
}
