import 'package:isar/isar.dart';

part 'cacao_lot.g.dart';

@collection
class CacaoLot {
  Id isarId = Isar.autoIncrement;

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
  
  late String statut; // draft, pending, transferred, transformed, exported
  
  @Index()
  late String syncStatus; // synced, pending, error
  
  late String createdBy;
  late DateTime createdAt;
  late DateTime updatedAt;

  CacaoLot();

  // On garde un constructeur nommé ou une méthode factory pour faciliter la création
  factory CacaoLot.create({
    required String lotId,
    required String farmerId,
    required String region,
    required double weightKg,
    required String species,
    required DateTime dateCollecte,
    required String coopName,
    required String createdBy,
    double? latitude,
    double? longitude,
  }) {
    final now = DateTime.now();
    return CacaoLot()
      ..lotId = lotId
      ..farmerId = farmerId
      ..region = region
      ..weightKg = weightKg
      ..species = species
      ..dateCollecte = dateCollecte
      ..coopName = coopName
      ..createdBy = createdBy
      ..latitude = latitude
      ..longitude = longitude
      ..statut = 'draft'
      ..syncStatus = 'pending'
      ..createdAt = now
      ..updatedAt = now;
  }
}
