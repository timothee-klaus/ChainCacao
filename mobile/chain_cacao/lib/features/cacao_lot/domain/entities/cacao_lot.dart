class CacaoLot {
  final String lotId;
  final String? lotHashOnChain;
  final String farmerId;
  final List<String> photoUrls;
  final List<String> photoHashes;
  final double? latitude;
  final double? longitude;
  final String region;
  final double weightKg;
  final String species;
  final DateTime dateCollecte;
  final String coopName;
  final String statut;
  final String syncStatus;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CacaoLot({
    required this.lotId,
    this.lotHashOnChain,
    required this.farmerId,
    this.photoUrls = const [],
    this.photoHashes = const [],
    this.latitude,
    this.longitude,
    required this.region,
    required this.weightKg,
    required this.species,
    required this.dateCollecte,
    required this.coopName,
    required this.statut,
    required this.syncStatus,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
