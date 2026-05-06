import 'package:fpdart/fpdart.dart';
import '../../domain/entities/parcelle.dart';
import '../../domain/repositories/parcelle_repository.dart';
import '../datasources/parcelle_local_data_source.dart';
import '../models/parcelle_model.dart';

class ParcelleRepositoryImpl implements ParcelleRepository {
  final ParcelleLocalDataSource localDataSource;

  ParcelleRepositoryImpl(this.localDataSource);

  @override
  Future<Either<String, List<Parcelle>>> getParcelles() async {
    try {
      final models = await localDataSource.getParcelles();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Parcelle>> saveParcelle(Parcelle parcelle) async {
    try {
      final model = ParcelleModel.fromEntity(parcelle);
      await localDataSource.saveParcelle(model);
      return Right(parcelle);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteParcelle(String id) async {
    try {
      await localDataSource.deleteParcelle(id);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
