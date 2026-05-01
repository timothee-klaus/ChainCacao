import 'package:isar/isar.dart';
import '../../domain/entities/cacao_lot.dart';

part 'cacao_lot_model.g.dart';

@Collection()
class CacaoLotModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String lotId;

  String? lotHashOnChain;
  late String farmerId;
  List<String> photoUrls = [];
  List<String> photoHashes = [];
  
  double? latitude;
  double? longitude;
  
  late String region;
  late double weightKg;
  late String species;
  late DateTime dateCollecte;
  late String coopName;
  
  late String statut;
  
  @Index()
  late String syncStatus;
  
  late String createdBy;
  late DateTime createdAt;
  late DateTime updatedAt;

  CacaoLotModel();

  /// Crée un modèle à partir d'une entité du domaine
  factory CacaoLotModel.fromEntity(CacaoLot entity) {
    return CacaoLotModel()
      ..lotId = entity.lotId
      ..lotHashOnChain = entity.lotHashOnChain
      ..farmerId = entity.farmerId
      ..photoUrls = entity.photoUrls
      ..photoHashes = entity.photoHashes
      ..latitude = entity.latitude
      ..longitude = entity.longitude
      ..region = entity.region
      ..weightKg = entity.weightKg
      ..species = entity.species
      ..dateCollecte = entity.dateCollecte
      ..coopName = entity.coopName
      ..statut = entity.statut
      ..syncStatus = entity.syncStatus
      ..createdBy = entity.createdBy
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  /// Convertit le modèle en entité du domaine
  CacaoLot toEntity() {
    return CacaoLot(
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
