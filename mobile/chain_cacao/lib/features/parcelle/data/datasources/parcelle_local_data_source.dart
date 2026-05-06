import 'package:isar/isar.dart';
import '../models/parcelle_model.dart';

abstract class ParcelleLocalDataSource {
  Future<List<ParcelleModel>> getParcelles();
  Future<void> saveParcelle(ParcelleModel parcelle);
  Future<void> deleteParcelle(String id);
}

class ParcelleLocalDataSourceImpl implements ParcelleLocalDataSource {
  final Isar isar;

  ParcelleLocalDataSourceImpl(this.isar);

  @override
  Future<List<ParcelleModel>> getParcelles() async {
    return await isar.parcelleModels.where().findAll();
  }

  @override
  Future<void> saveParcelle(ParcelleModel parcelle) async {
    await isar.writeTxn(() async {
      await isar.parcelleModels.put(parcelle);
    });
  }

  @override
  Future<void> deleteParcelle(String id) async {
    await isar.writeTxn(() async {
      await isar.parcelleModels.filter().idEqualTo(id).deleteAll();
    });
  }
}
