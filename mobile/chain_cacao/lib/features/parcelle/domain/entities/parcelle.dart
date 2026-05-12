class Parcelle {
  final String id;
  final String name;
  final String ownerName;
  final double area; // in hectares
  final List<ParcelleCoordinate> polygon;
  final DateTime createdAt;
  final String? description;

  const Parcelle({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.area,
    required this.polygon,
    required this.createdAt,
    this.description,
  });

  // Calculate area if needed, but we'll store it as provided by the recorder logic
}

class ParcelleCoordinate {
  final double latitude;
  final double longitude;

  const ParcelleCoordinate({required this.latitude, required this.longitude});
}
