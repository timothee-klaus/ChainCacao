import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/cacao_lot/data/models/cacao_lot_model.dart';
import '../../features/parcelle/data/models/parcelle_model.dart';
import 'queue_item.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([
        CacaoLotModelSchema,
        QueueItemSchema,
        ParcelleModelSchema,
      ], directory: dir.path);
    }
    return Future.value(Isar.getInstance());
  }
}

final isarServiceProvider = Provider<IsarService>((ref) => IsarService());
