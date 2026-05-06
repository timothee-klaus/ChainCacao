import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/isar_service.dart';
import 'package:isar/isar.dart';
import '../../../features/cacao_lot/data/models/cacao_lot_model.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) async* {
  // On récupère l'état initial
  final initial = await Connectivity().checkConnectivity();
  yield initial;
  // Puis on écoute les changements
  yield* Connectivity().onConnectivityChanged;
});

final pendingSyncCountProvider = StreamProvider<int>((ref) async* {
  final isar = await ref.watch(isarServiceProvider).db;
  yield* isar.collection<CacaoLotModel>()
      .filter()
      .syncStatusEqualTo('pending')
      .watch(fireImmediately: true)
      .map((items) => items.length);
});
