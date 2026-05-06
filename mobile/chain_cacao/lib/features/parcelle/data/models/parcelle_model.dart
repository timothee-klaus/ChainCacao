import 'package:isar/isar.dart';
import '../../domain/entities/parcelle.dart' as entity;

part 'parcelle_model.g.dart';

@collection
class ParcelleModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String id = '';

  String name = '';
  String ownerName = '';
  double area = 0.0;
  List<CoordinateModel> polygon = [];
  DateTime createdAt = DateTime.now();
  String? description;

  ParcelleModel();

  factory ParcelleModel.fromEntity(entity.Parcelle parcelle) {
    return ParcelleModel()
      ..id = parcelle.id
      ..name = parcelle.name
      ..ownerName = parcelle.ownerName
      ..area = parcelle.area
      ..polygon = parcelle.polygon
          .map((c) => CoordinateModel()
            ..latitude = c.latitude
            ..longitude = c.longitude)
          .toList()
      ..createdAt = parcelle.createdAt
      ..description = parcelle.description;
  }

  entity.Parcelle toEntity() {
    return entity.Parcelle(
      id: id,
      name: name,
      ownerName: ownerName,
      area: area,
      polygon: polygon
          .map((c) => entity.ParcelleCoordinate(
                latitude: c.latitude,
                longitude: c.longitude,
              ))
          .toList(),
      createdAt: createdAt,
      description: description,
    );
  }
}

@embedded
class CoordinateModel {
  double latitude = 0.0;
  double longitude = 0.0;
}
