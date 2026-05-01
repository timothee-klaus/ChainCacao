import 'package:fpdart/fpdart.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/repositories/cacao_lot_repository.dart';
import '../datasources/cacao_lot_local_data_source.dart';
import '../models/cacao_lot_model.dart';

/// Implémentation concrète du repository CacaoLot.
/// Fait le pont entre les sources de données (Data) et les contrats (Domain).
class CacaoLotRepositoryImpl implements CacaoLotRepository {
  final CacaoLotLocalDataSource localDataSource;

  CacaoLotRepositoryImpl(this.localDataSource);

  @override
  Future<Either<String, void>> saveLot(CacaoLot lot) async {
    try {
      final model = CacaoLotModel.fromEntity(lot);
      await localDataSource.saveLot(model);
      return right(null);
    } catch (e) {
      return left('Échec de la sauvegarde locale du lot : ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<CacaoLot>>> getLots() async {
    try {
      final models = await localDataSource.getLots();
      // Transformation des modèles Data en entités Domaine
      final entities = models.map((m) => m.toEntity()).toList();
      return right(entities);
    } catch (e) {
      return left('Erreur lors de la récupération des lots : ${e.toString()}');
    }
  }
}
