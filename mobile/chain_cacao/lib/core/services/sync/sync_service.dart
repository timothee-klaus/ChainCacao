import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/isar_service.dart';
import '../../database/queue_item.dart';
import '../../../features/cacao_lot/data/models/cacao_lot_model.dart';
import '../../../features/cacao_lot/presentation/providers/cacao_lot_list_provider.dart';

class SyncService {
  final IsarService _isarService;
  final Ref _ref;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._isarService, this._ref) {
    _startListeningToConnectivity();
  }

  void _startListeningToConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final hasConnection = results.any(
        (r) =>
            r == ConnectivityResult.mobile ||
            r == ConnectivityResult.wifi ||
            r == ConnectivityResult.ethernet,
      );

      if (hasConnection) {
        triggerSync();
      }
    });
  }

  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final isar = await _isarService.db;

      final pendingItems = await isar
          .collection<QueueItem>()
          .filter()
          .statutEqualTo('pending')
          .sortByDateCreation()
          .findAll();

      if (pendingItems.isEmpty) return;

      for (var item in pendingItems) {
        final success = await _processQueueItem(item, isar);

        await isar.writeTxn(() async {
          if (success) {
            item.statut = 'sent';
            await isar.collection<QueueItem>().delete(item.isarId);
          } else {
            item.tentatives += 1;
            if (item.tentatives >= 5) {
              item.statut = 'failed';
            }
            await isar.collection<QueueItem>().put(item);
          }
        });
      }

      // Rafraîchir la liste des lots pour l'UI
      _ref.invalidate(cacaoLotListNotifierProvider);
    } catch (e) {
      // Log error
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processQueueItem(QueueItem item, Isar isar) async {
    if (item.payloadType == 'create_lot') {
      final lot = await isar
          .collection<CacaoLotModel>()
          .filter()
          .lotIdEqualTo(item.payloadRef)
          .findFirst();
      if (lot == null) return true;

      try {
        // Simulation d'un délai réseau pour le réalisme hackathon
        await Future.delayed(const Duration(seconds: 1));

        // En mode démo hackathon, on force le succès même si le serveur simulé ne répond pas
        // car l'objectif est de montrer la transition vers la blockchain

        // Mise à jour du statut de synchro du lot local
        await isar.writeTxn(() async {
          lot.syncStatus = 'synced';
          // On simule un hash de transaction blockchain
          lot.lotHashOnChain =
              '0x${lot.lotId.hashCode.toRadixString(16)}${DateTime.now().millisecond.toRadixString(16)}';
          lot.updatedAt = DateTime.now();
          await isar.collection<CacaoLotModel>().put(lot);
        });

        return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}

final syncServiceProvider = Provider<SyncService>((ref) {
  final isarService = ref.read(isarServiceProvider);
  return SyncService(isarService, ref);
});
