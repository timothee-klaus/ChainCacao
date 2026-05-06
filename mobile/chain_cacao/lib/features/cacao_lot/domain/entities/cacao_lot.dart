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
  final String variete;
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
    required this.variete,
    required this.dateCollecte,
    required this.coopName,
    required this.statut,
    required this.syncStatus,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  CacaoLot copyWith({
    String? lotId,
    String? lotHashOnChain,
    String? farmerId,
    List<String>? photoUrls,
    List<String>? photoHashes,
    double? latitude,
    double? longitude,
    String? region,
    double? weightKg,
    String? species,
    String? variete,
    DateTime? dateCollecte,
    String? coopName,
    String? statut,
    String? syncStatus,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CacaoLot(
      lotId: lotId ?? this.lotId,
      lotHashOnChain: lotHashOnChain ?? this.lotHashOnChain,
      farmerId: farmerId ?? this.farmerId,
      photoUrls: photoUrls ?? this.photoUrls,
      photoHashes: photoHashes ?? this.photoHashes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      weightKg: weightKg ?? this.weightKg,
      species: species ?? this.species,
      variete: variete ?? this.variete,
      dateCollecte: dateCollecte ?? this.dateCollecte,
      coopName: coopName ?? this.coopName,
      statut: statut ?? this.statut,
      syncStatus: syncStatus ?? this.syncStatus,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
