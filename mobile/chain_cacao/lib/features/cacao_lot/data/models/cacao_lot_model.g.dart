// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cacao_lot_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCacaoLotModelCollection on Isar {
  IsarCollection<CacaoLotModel> get cacaoLotModels => this.collection();
}

const CacaoLotModelSchema = CollectionSchema(
  name: r'CacaoLotModel',
  id: 339080984226598034,
  properties: {
    r'coopName': PropertySchema(
      id: 0,
      name: r'coopName',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 2,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'dateCollecte': PropertySchema(
      id: 3,
      name: r'dateCollecte',
      type: IsarType.dateTime,
    ),
    r'farmerId': PropertySchema(
      id: 4,
      name: r'farmerId',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 5,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 6,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'lotHashOnChain': PropertySchema(
      id: 7,
      name: r'lotHashOnChain',
      type: IsarType.string,
    ),
    r'lotId': PropertySchema(id: 8, name: r'lotId', type: IsarType.string),
    r'parcelleId': PropertySchema(
      id: 9,
      name: r'parcelleId',
      type: IsarType.string,
    ),
    r'photoHashes': PropertySchema(
      id: 10,
      name: r'photoHashes',
      type: IsarType.stringList,
    ),
    r'photoUrls': PropertySchema(
      id: 11,
      name: r'photoUrls',
      type: IsarType.stringList,
    ),
    r'region': PropertySchema(id: 12, name: r'region', type: IsarType.string),
    r'species': PropertySchema(id: 13, name: r'species', type: IsarType.string),
    r'statut': PropertySchema(id: 14, name: r'statut', type: IsarType.string),
    r'syncStatus': PropertySchema(
      id: 15,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'variete': PropertySchema(id: 17, name: r'variete', type: IsarType.string),
    r'weightKg': PropertySchema(
      id: 18,
      name: r'weightKg',
      type: IsarType.double,
    ),
  },
  estimateSize: _cacaoLotModelEstimateSize,
  serialize: _cacaoLotModelSerialize,
  deserialize: _cacaoLotModelDeserialize,
  deserializeProp: _cacaoLotModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'lotId': IndexSchema(
      id: 7594258205857764483,
      name: r'lotId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'lotId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _cacaoLotModelGetId,
  getLinks: _cacaoLotModelGetLinks,
  attach: _cacaoLotModelAttach,
  version: '3.1.0+1',
);

int _cacaoLotModelEstimateSize(
  CacaoLotModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.coopName.length * 3;
  bytesCount += 3 + object.createdBy.length * 3;
  bytesCount += 3 + object.farmerId.length * 3;
  {
    final value = object.lotHashOnChain;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lotId.length * 3;
  {
    final value = object.parcelleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.photoHashes.length * 3;
  {
    for (var i = 0; i < object.photoHashes.length; i++) {
      final value = object.photoHashes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.photoUrls.length * 3;
  {
    for (var i = 0; i < object.photoUrls.length; i++) {
      final value = object.photoUrls[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.region.length * 3;
  bytesCount += 3 + object.species.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  bytesCount += 3 + object.syncStatus.length * 3;
  bytesCount += 3 + object.variete.length * 3;
  return bytesCount;
}

void _cacaoLotModelSerialize(
  CacaoLotModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.coopName);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.createdBy);
  writer.writeDateTime(offsets[3], object.dateCollecte);
  writer.writeString(offsets[4], object.farmerId);
  writer.writeDouble(offsets[5], object.latitude);
  writer.writeDouble(offsets[6], object.longitude);
  writer.writeString(offsets[7], object.lotHashOnChain);
  writer.writeString(offsets[8], object.lotId);
  writer.writeString(offsets[9], object.parcelleId);
  writer.writeStringList(offsets[10], object.photoHashes);
  writer.writeStringList(offsets[11], object.photoUrls);
  writer.writeString(offsets[12], object.region);
  writer.writeString(offsets[13], object.species);
  writer.writeString(offsets[14], object.statut);
  writer.writeString(offsets[15], object.syncStatus);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeString(offsets[17], object.variete);
  writer.writeDouble(offsets[18], object.weightKg);
}

CacaoLotModel _cacaoLotModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CacaoLotModel();
  object.coopName = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.createdBy = reader.readString(offsets[2]);
  object.dateCollecte = reader.readDateTime(offsets[3]);
  object.farmerId = reader.readString(offsets[4]);
  object.isarId = id;
  object.latitude = reader.readDoubleOrNull(offsets[5]);
  object.longitude = reader.readDoubleOrNull(offsets[6]);
  object.lotHashOnChain = reader.readStringOrNull(offsets[7]);
  object.lotId = reader.readString(offsets[8]);
  object.parcelleId = reader.readStringOrNull(offsets[9]);
  object.photoHashes = reader.readStringList(offsets[10]) ?? [];
  object.photoUrls = reader.readStringList(offsets[11]) ?? [];
  object.region = reader.readString(offsets[12]);
  object.species = reader.readString(offsets[13]);
  object.statut = reader.readString(offsets[14]);
  object.syncStatus = reader.readString(offsets[15]);
  object.updatedAt = reader.readDateTime(offsets[16]);
  object.variete = reader.readString(offsets[17]);
  object.weightKg = reader.readDouble(offsets[18]);
  return object;
}

P _cacaoLotModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readStringList(offset) ?? []) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cacaoLotModelGetId(CacaoLotModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cacaoLotModelGetLinks(CacaoLotModel object) {
  return [];
}

void _cacaoLotModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CacaoLotModel object,
) {
  object.isarId = id;
}

extension CacaoLotModelByIndex on IsarCollection<CacaoLotModel> {
  Future<CacaoLotModel?> getByLotId(String lotId) {
    return getByIndex(r'lotId', [lotId]);
  }

  CacaoLotModel? getByLotIdSync(String lotId) {
    return getByIndexSync(r'lotId', [lotId]);
  }

  Future<bool> deleteByLotId(String lotId) {
    return deleteByIndex(r'lotId', [lotId]);
  }

  bool deleteByLotIdSync(String lotId) {
    return deleteByIndexSync(r'lotId', [lotId]);
  }

  Future<List<CacaoLotModel?>> getAllByLotId(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'lotId', values);
  }

  List<CacaoLotModel?> getAllByLotIdSync(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'lotId', values);
  }

  Future<int> deleteAllByLotId(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'lotId', values);
  }

  int deleteAllByLotIdSync(List<String> lotIdValues) {
    final values = lotIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'lotId', values);
  }

  Future<Id> putByLotId(CacaoLotModel object) {
    return putByIndex(r'lotId', object);
  }

  Id putByLotIdSync(CacaoLotModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'lotId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLotId(List<CacaoLotModel> objects) {
    return putAllByIndex(r'lotId', objects);
  }

  List<Id> putAllByLotIdSync(
    List<CacaoLotModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'lotId', objects, saveLinks: saveLinks);
  }
}

extension CacaoLotModelQueryWhereSort
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QWhere> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CacaoLotModelQueryWhere
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QWhereClause> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause> isarIdEqualTo(
    Id isarId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause> isarIdLessThan(
    Id isarId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause> lotIdEqualTo(
    String lotId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'lotId', value: [lotId]),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterWhereClause> lotIdNotEqualTo(
    String lotId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lotId',
                lower: [],
                upper: [lotId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lotId',
                lower: [lotId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lotId',
                lower: [lotId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'lotId',
                lower: [],
                upper: [lotId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CacaoLotModelQueryFilter
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QFilterCondition> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coopName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coopName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coopName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coopName', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  coopNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coopName', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdBy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'createdBy',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'createdBy',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdBy', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'createdBy', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  dateCollecteEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateCollecte', value: value),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  dateCollecteGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateCollecte',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  dateCollecteLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateCollecte',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  dateCollecteBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateCollecte',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'farmerId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'farmerId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'farmerId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'farmerId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  farmerIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'farmerId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'latitude'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'latitude'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'latitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'latitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'latitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'latitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'longitude'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'longitude'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'longitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'longitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'longitude',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'longitude',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lotHashOnChain'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lotHashOnChain'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lotHashOnChain',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lotHashOnChain',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lotHashOnChain',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lotHashOnChain', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotHashOnChainIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lotHashOnChain', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lotId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lotId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lotId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lotId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  lotIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lotId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'parcelleId'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'parcelleId'),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'parcelleId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'parcelleId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'parcelleId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'parcelleId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  parcelleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'parcelleId', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photoHashes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photoHashes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photoHashes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photoHashes', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photoHashes', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoHashes', length, true, length, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoHashes', 0, true, 0, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoHashes', 0, false, 999999, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoHashes', 0, true, length, include);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoHashes', length, include, 999999, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoHashesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoHashes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photoUrls',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photoUrls',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photoUrls',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photoUrls', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photoUrls', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoUrls', length, true, length, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoUrls', 0, true, 0, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoUrls', 0, false, 999999, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoUrls', 0, true, length, include);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoUrls', length, include, 999999, true);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  photoUrlsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoUrls',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'region',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'region',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'region',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'region', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  regionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'region', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'species',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'species',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'species',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'species', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  speciesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'species', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'statut',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'statut',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'statut',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'statut', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'statut', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'syncStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'syncStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'syncStatus', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'variete',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'variete',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'variete',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'variete', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  varieteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'variete', value: ''),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  weightKgEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weightKg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  weightKgGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weightKg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  weightKgLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weightKg',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterFilterCondition>
  weightKgBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weightKg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }
}

extension CacaoLotModelQueryObject
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QFilterCondition> {}

extension CacaoLotModelQueryLinks
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QFilterCondition> {}

extension CacaoLotModelQuerySortBy
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QSortBy> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByCoopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coopName', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByCoopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coopName', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByDateCollecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByFarmerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByFarmerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByLotHashOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotHashOnChain', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByLotHashOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotHashOnChain', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByParcelleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelleId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByParcelleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelleId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortBySpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortBySpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByVariete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variete', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByVarieteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variete', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> sortByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  sortByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension CacaoLotModelQuerySortThenBy
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QSortThenBy> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByCoopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coopName', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByCoopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coopName', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByDateCollecteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCollecte', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByFarmerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByFarmerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmerId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByLotHashOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotHashOnChain', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByLotHashOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotHashOnChain', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByLotId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByLotIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lotId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByParcelleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelleId', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByParcelleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parcelleId', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenBySpecies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenBySpeciesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'species', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByVariete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variete', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByVarieteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variete', Sort.desc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy> thenByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.asc);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QAfterSortBy>
  thenByWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightKg', Sort.desc);
    });
  }
}

extension CacaoLotModelQueryWhereDistinct
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> {
  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByCoopName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coopName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByCreatedBy({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct>
  distinctByDateCollecte() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCollecte');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByFarmerId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmerId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct>
  distinctByLotHashOnChain({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'lotHashOnChain',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByLotId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByParcelleId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parcelleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct>
  distinctByPhotoHashes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoHashes');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByPhotoUrls() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoUrls');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByRegion({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'region', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctBySpecies({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'species', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByStatut({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctBySyncStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByVariete({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variete', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CacaoLotModel, CacaoLotModel, QDistinct> distinctByWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weightKg');
    });
  }
}

extension CacaoLotModelQueryProperty
    on QueryBuilder<CacaoLotModel, CacaoLotModel, QQueryProperty> {
  QueryBuilder<CacaoLotModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> coopNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coopName');
    });
  }

  QueryBuilder<CacaoLotModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<CacaoLotModel, DateTime, QQueryOperations>
  dateCollecteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCollecte');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> farmerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmerId');
    });
  }

  QueryBuilder<CacaoLotModel, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<CacaoLotModel, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<CacaoLotModel, String?, QQueryOperations>
  lotHashOnChainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotHashOnChain');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> lotIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotId');
    });
  }

  QueryBuilder<CacaoLotModel, String?, QQueryOperations> parcelleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parcelleId');
    });
  }

  QueryBuilder<CacaoLotModel, List<String>, QQueryOperations>
  photoHashesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoHashes');
    });
  }

  QueryBuilder<CacaoLotModel, List<String>, QQueryOperations>
  photoUrlsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoUrls');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> regionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'region');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> speciesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'species');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<CacaoLotModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CacaoLotModel, String, QQueryOperations> varieteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variete');
    });
  }

  QueryBuilder<CacaoLotModel, double, QQueryOperations> weightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightKg');
    });
  }
}
