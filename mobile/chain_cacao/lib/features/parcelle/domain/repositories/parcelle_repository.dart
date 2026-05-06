import 'package:fpdart/fpdart.dart';
import '../entities/parcelle.dart';

abstract class ParcelleRepository {
  Future<Either<String, List<Parcelle>>> getParcelles();
  Future<Either<String, Parcelle>> saveParcelle(Parcelle parcelle);
  Future<Either<String, Unit>> deleteParcelle(String id);
}
