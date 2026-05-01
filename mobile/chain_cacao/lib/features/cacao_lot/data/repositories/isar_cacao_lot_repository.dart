import 'package:isar/isar.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/repositories/cacao_lot_repository.dart';
import '../../../../core/database/isar_service.dart';
import '../../../../core/database/queue_item.dart';

class IsarCacaoLotRepository implements CacaoLotRepository {
  final IsarService _isarService;

  IsarCacaoLotRepository(this._isarService);

  @override
  Future<void> saveLot(CacaoLot lot) async {
    final isar = await _isarService.db;
    
    // Création de l'entrée dans la file d'attente pour synchronisation
    final queueItem = QueueItem.create(
      payloadType: 'create_lot',
      payloadRef: lot.lotId,
    );

    // Transaction Isar pour garantir l'atomicité de la sauvegarde locale
    await isar.writeTxn(() async {
      await isar.collection<CacaoLot>().put(lot);
      await isar.collection<QueueItem>().put(queueItem);
    });
  }

  @override
  Future<List<CacaoLot>> getLots() async {
    final isar = await _isarService.db;
    return await isar.collection<CacaoLot>().where().findAll();
  }
}
