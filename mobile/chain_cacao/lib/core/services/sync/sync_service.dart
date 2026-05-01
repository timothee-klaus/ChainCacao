import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/isar_service.dart';
import '../../database/queue_item.dart';
import '../../network/dio_client.dart';
import '../../../features/cacao_lot/domain/entities/cacao_lot.dart';

class SyncService {
  final IsarService _isarService;
  final Dio _dio;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._isarService, this._dio) {
    _startListeningToConnectivity();
  }

  void _startListeningToConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final hasConnection = results.any((r) => 
        r == ConnectivityResult.mobile || 
        r == ConnectivityResult.wifi || 
        r == ConnectivityResult.ethernet
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
      
      // On récupère les items en attente, triés par date
      final pendingItems = await isar.collection<QueueItem>()
          .filter()
          .statutEqualTo('pending')
          .sortByDateCreation()
          .findAll();

      for (var item in pendingItems) {
        final success = await _processQueueItem(item, isar);
        
        await isar.writeTxn(() async {
          if (success) {
            item.statut = 'sent';
            // On peut choisir de supprimer l'item de la file ou de le garder avec le statut 'sent'
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
    } catch (e) {
      print("Erreur globale lors de la synchronisation: $e");
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> _processQueueItem(QueueItem item, Isar isar) async {
    if (item.payloadType == 'create_lot') {
      final lot = await isar.collection<CacaoLot>().filter().lotIdEqualTo(item.payloadRef).findFirst();
      if (lot == null) return true; // Lot introuvable, on considère l'item comme traité (ou erreur)

      try {
        final response = await _dio.post('/lots', data: {
          'lotId': lot.lotId,
          'farmerId': lot.farmerId,
          'weightKg': lot.weightKg,
          'species': lot.species,
          'latitude': lot.latitude,
          'longitude': lot.longitude,
          'region': lot.region,
          'dateCollecte': lot.dateCollecte.toIso8601String(),
          'coopName': lot.coopName,
          'createdBy': lot.createdBy,
          'statut': lot.statut,
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Mise à jour du statut de synchro du lot local
          await isar.writeTxn(() async {
            lot.syncStatus = 'synced';
            lot.updatedAt = DateTime.now();
            await isar.collection<CacaoLot>().put(lot);
          });
          return true;
        }
        return false;
      } on DioException catch (e) {
        print("Échec de la synchro du lot ${lot.lotId}: ${e.message}");
        return false;
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
  final dio = ref.read(dioProvider);
  return SyncService(isarService, dio);
});
