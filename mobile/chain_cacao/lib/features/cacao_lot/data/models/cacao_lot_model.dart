import 'package:isar/isar.dart';
import '../../domain/entities/cacao_lot.dart' as entity;

part 'cacao_lot_model.g.dart';

@collection
class CacaoLotModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String lotId = '';

  String? lotHashOnChain;
  String farmerId = '';
  List<String> photoUrls = [];
  List<String> photoHashes = [];
  
  double? latitude;
  double? longitude;
  
  String region = 'Plateaux';
  double weightKg = 0;
  String species = 'Cacao';
  String variete = '';
  DateTime dateCollecte = DateTime.now();
  String coopName = '';
  
  String statut = 'draft'; 
  String syncStatus = 'pending'; 
  
  String createdBy = '';
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  CacaoLotModel();

  factory CacaoLotModel.fromEntity(entity.CacaoLot lot) {
    return CacaoLotModel()
      ..lotId = lot.lotId
      ..lotHashOnChain = lot.lotHashOnChain
      ..farmerId = lot.farmerId
      ..photoUrls = lot.photoUrls
      ..photoHashes = lot.photoHashes
      ..latitude = lot.latitude
      ..longitude = lot.longitude
      ..region = lot.region
      ..weightKg = lot.weightKg
      ..species = lot.species
      ..variete = lot.variete
      ..dateCollecte = lot.dateCollecte
      ..coopName = lot.coopName
      ..statut = lot.statut
      ..syncStatus = lot.syncStatus
      ..createdBy = lot.createdBy
      ..createdAt = lot.createdAt
      ..updatedAt = lot.updatedAt;
  }

  entity.CacaoLot toEntity() {
    return entity.CacaoLot(
      lotId: lotId,
      lotHashOnChain: lotHashOnChain,
      farmerId: farmerId,
      photoUrls: photoUrls,
      photoHashes: photoHashes,
      latitude: latitude,
      longitude: longitude,
      region: region,
      weightKg: weightKg,
      species: species,
      variete: variete,
      dateCollecte: dateCollecte,
      coopName: coopName,
      statut: statut,
      syncStatus: syncStatus,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
