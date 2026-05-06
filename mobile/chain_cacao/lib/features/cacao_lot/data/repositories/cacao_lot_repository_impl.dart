import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../../../../core/database/queue_item.dart';
import '../../domain/entities/cacao_lot.dart';
import '../../domain/repositories/cacao_lot_repository.dart';
import '../models/cacao_lot_model.dart';

class CacaoLotRepositoryImpl implements CacaoLotRepository {
  final IsarService isarService;

  CacaoLotRepositoryImpl(this.isarService);

  @override
  Future<Either<String, CacaoLot>> saveLot(CacaoLot lot) async {
    try {
      final isar = await isarService.db;
      final model = CacaoLotModel.fromEntity(lot);
      
      // On crée un item dans la file de synchronisation
      final queueItem = QueueItem.create(
        payloadType: 'create_lot',
        payloadRef: lot.lotId,
      );

      await isar.writeTxn(() async {
        // Sauvegarde du lot
        await isar.collection<CacaoLotModel>().put(model);
        // Sauvegarde dans la file de synchro
        await isar.collection<QueueItem>().put(queueItem);
      });
      
      return right(model.toEntity());
    } catch (e, stack) {
      // Log détaillé pour le développeur
      debugPrint('Erreur Isar SaveLot: $e');
      debugPrint('Stacktrace: $stack');
      return left('Erreur lors de la sauvegarde locale : $e');
    }
  }

  @override
  Future<Either<String, List<CacaoLot>>> getAllLots() async {
    try {
      final isar = await isarService.db;
      final models = await isar.collection<CacaoLotModel>().where().findAll();
      final entities = models.map((m) => m.toEntity()).toList();
      
      // Injection de lots mocks pour la démo si la liste est vide ou pour compléter
      if (entities.length < 2) {
        entities.addAll(_getMockLots());
      }
      
      return right(entities);
    } catch (e) {
      return left('Erreur lors de la récupération des lots : $e');
    }
  }

  List<CacaoLot> _getMockLots() {
    final now = DateTime.now();
    return [
      CacaoLot(
        lotId: '7d8f9e0a-1b2c-3d4e-5f6g-7h8i9j0k1l2m',
        farmerId: 'AGRI-TOGO-001',
        region: 'Plateaux',
        weightKg: 250.0,
        species: 'Cacao',
        variete: 'Forastero Premium',
        dateCollecte: now.subtract(const Duration(days: 1, hours: 3)),
        coopName: 'Coopérative Miabe',
        statut: 'pending',
        syncStatus: 'synced',
        createdBy: 'USER-01',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
        lotHashOnChain: '0x742d...f3a1',
      ),
      CacaoLot(
        lotId: 'a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6',
        farmerId: 'AGRI-TOGO-001',
        region: 'Maritime',
        weightKg: 250.0,
        species: 'Cacao',
        variete: 'Forastero',
        dateCollecte: now.subtract(const Duration(days: 2)),
        coopName: 'SCOOPS-Togo',
        statut: 'verified',
        syncStatus: 'synced',
        createdBy: 'AGRI-TOGO-001',
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      CacaoLot(
        lotId: '1a2b3c4d-5e6f-7g8h-9i0j-k1l2m3n4o5p6',
        farmerId: 'AGRI-TOGO-001',
        region: 'Plateaux',
        weightKg: 120.0,
        species: 'Café',
        variete: 'Robusta',
        dateCollecte: now.subtract(const Duration(days: 5)),
        coopName: 'SCOOPS-Togo',
        statut: 'draft',
        syncStatus: 'pending',
        createdBy: 'AGRI-TOGO-001',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Future<Either<String, List<CacaoLot>>> getPendingLots() async {
    try {
      final isar = await isarService.db;
      final models = await isar.collection<CacaoLotModel>()
          .filter()
          .syncStatusEqualTo('pending')
          .findAll();
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return left('Erreur lors de la récupération des lots en attente : $e');
    }
  }

  @override
  Future<Either<String, Unit>> markAsSynced(String lotId, String txHash) async {
    try {
      final isar = await isarService.db;
      await isar.writeTxn(() async {
        final lot = await isar.collection<CacaoLotModel>().filter().lotIdEqualTo(lotId).findFirst();
        if (lot != null) {
          lot.syncStatus = 'synced';
          lot.lotHashOnChain = txHash;
          lot.statut = 'pending'; // Passe de draft à pending (attente de validation coop)
          lot.updatedAt = DateTime.now();
          await isar.collection<CacaoLotModel>().put(lot);
        }
      });
      return right(unit);
    } catch (e) {
      return left('Erreur lors de la mise à jour du statut de synchro : $e');
    }
  }
}
