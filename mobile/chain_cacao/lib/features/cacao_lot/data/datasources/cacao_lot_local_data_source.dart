import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../../../../core/database/queue_item.dart';
import '../models/cacao_lot_model.dart';

/// Interface pour la source de données locale des lots de cacao.
abstract class CacaoLotLocalDataSource {
  Future<void> saveLot(CacaoLotModel lot);
  Future<List<CacaoLotModel>> getLots();
}

class CacaoLotLocalDataSourceImpl implements CacaoLotLocalDataSource {
  final IsarService isarService;

  CacaoLotLocalDataSourceImpl(this.isarService);

  @override
  Future<void> saveLot(CacaoLotModel lot) async {
    final isar = await isarService.db;
    
    // Création de l'item dans la file d'attente pour la synchronisation ultérieure
    final queueItem = QueueItem.create(
      payloadType: 'create_lot',
      payloadRef: lot.lotId,
    );

    // Persistance locale atomique
    await isar.writeTxn(() async {
      await isar.collection<CacaoLotModel>().put(lot);
      await isar.collection<QueueItem>().put(queueItem);
    });
  }

  @override
  Future<List<CacaoLotModel>> getLots() async {
    final isar = await isarService.db;
    return await isar.collection<CacaoLotModel>().where().findAll();
  }
}
