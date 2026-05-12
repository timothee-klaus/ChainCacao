// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcelle_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParcelleModelCollection on Isar {
  IsarCollection<ParcelleModel> get parcelleModels => this.collection();
}

const ParcelleModelSchema = CollectionSchema(
  name: r'ParcelleModel',
  id: 1372172006927056199,
  properties: {
    r'area': PropertySchema(id: 0, name: r'area', type: IsarType.double),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 3, name: r'id', type: IsarType.string),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'ownerName': PropertySchema(
      id: 5,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'polygon': PropertySchema(
      id: 6,
      name: r'polygon',
      type: IsarType.objectList,
      target: r'CoordinateModel',
    ),
  },
  estimateSize: _parcelleModelEstimateSize,
  serialize: _parcelleModelSerialize,
  deserialize: _parcelleModelDeserialize,
  deserializeProp: _parcelleModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'CoordinateModel': CoordinateModelSchema},
  getId: _parcelleModelGetId,
  getLinks: _parcelleModelGetLinks,
  attach: _parcelleModelAttach,
  version: '3.1.0+1',
);

int _parcelleModelEstimateSize(
  ParcelleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.ownerName.length * 3;
  bytesCount += 3 + object.polygon.length * 3;
  {
    final offsets = allOffsets[CoordinateModel]!;
    for (var i = 0; i < object.polygon.length; i++) {
      final value = object.polygon[i];
      bytesCount += CoordinateModelSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _parcelleModelSerialize(
  ParcelleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.area);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.ownerName);
  writer.writeObjectList<CoordinateModel>(
    offsets[6],
    allOffsets,
    CoordinateModelSchema.serialize,
    object.polygon,
  );
}

ParcelleModel _parcelleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParcelleModel();
  object.area = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.description = reader.readStringOrNull(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.isarId = id;
  object.name = reader.readString(offsets[4]);
  object.ownerName = reader.readString(offsets[5]);
  object.polygon =
      reader.readObjectList<CoordinateModel>(
        offsets[6],
        CoordinateModelSchema.deserialize,
        allOffsets,
        CoordinateModel(),
      ) ??
      [];
  return object;
}

P _parcelleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readObjectList<CoordinateModel>(
                offset,
                CoordinateModelSchema.deserialize,
                allOffsets,
                CoordinateModel(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _parcelleModelGetId(ParcelleModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _parcelleModelGetLinks(ParcelleModel object) {
  return [];
}

void _parcelleModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ParcelleModel object,
) {
  object.isarId = id;
}

extension ParcelleModelByIndex on IsarCollection<ParcelleModel> {
  Future<ParcelleModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  ParcelleModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<ParcelleModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<ParcelleModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(ParcelleModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(ParcelleModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<ParcelleModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<ParcelleModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension ParcelleModelQueryWhereSort
    on QueryBuilder<ParcelleModel, ParcelleModel, QWhere> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParcelleModelQueryWhere
    on QueryBuilder<ParcelleModel, ParcelleModel, QWhereClause> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause> isarIdEqualTo(
    Id isarId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause> isarIdLessThan(
    Id isarId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause> idEqualTo(
    String id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterWhereClause> idNotEqualTo(
    String id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ParcelleModelQueryFilter
    on QueryBuilder<ParcelleModel, ParcelleModel, QFilterCondition> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> areaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'area',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  areaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'area',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  areaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'area',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> areaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'area',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> idMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
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

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ownerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ownerName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ownerName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerName', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerName', value: ''),
      );
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'polygon', length, true, length, true);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'polygon', 0, true, 0, true);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'polygon', 0, false, 999999, true);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'polygon', 0, true, length, include);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'polygon', length, include, 999999, true);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'polygon',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ParcelleModelQueryObject
    on QueryBuilder<ParcelleModel, ParcelleModel, QFilterCondition> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterFilterCondition>
  polygonElement(FilterQuery<CoordinateModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'polygon');
    });
  }
}

extension ParcelleModelQueryLinks
    on QueryBuilder<ParcelleModel, ParcelleModel, QFilterCondition> {}

extension ParcelleModelQuerySortBy
    on QueryBuilder<ParcelleModel, ParcelleModel, QSortBy> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }
}

extension ParcelleModelQuerySortThenBy
    on QueryBuilder<ParcelleModel, ParcelleModel, QSortThenBy> {
  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'area', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy> thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QAfterSortBy>
  thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }
}

extension ParcelleModelQueryWhereDistinct
    on QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> {
  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctByArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'area');
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctById({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelleModel, ParcelleModel, QDistinct> distinctByOwnerName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }
}

extension ParcelleModelQueryProperty
    on QueryBuilder<ParcelleModel, ParcelleModel, QQueryProperty> {
  QueryBuilder<ParcelleModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ParcelleModel, double, QQueryOperations> areaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'area');
    });
  }

  QueryBuilder<ParcelleModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ParcelleModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<ParcelleModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParcelleModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ParcelleModel, String, QQueryOperations> ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<ParcelleModel, List<CoordinateModel>, QQueryOperations>
  polygonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'polygon');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CoordinateModelSchema = Schema(
  name: r'CoordinateModel',
  id: 3687617014073456774,
  properties: {
    r'latitude': PropertySchema(
      id: 0,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 1,
      name: r'longitude',
      type: IsarType.double,
    ),
  },
  estimateSize: _coordinateModelEstimateSize,
  serialize: _coordinateModelSerialize,
  deserialize: _coordinateModelDeserialize,
  deserializeProp: _coordinateModelDeserializeProp,
);

int _coordinateModelEstimateSize(
  CoordinateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _coordinateModelSerialize(
  CoordinateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.latitude);
  writer.writeDouble(offsets[1], object.longitude);
}

CoordinateModel _coordinateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoordinateModel();
  object.latitude = reader.readDouble(offsets[0]);
  object.longitude = reader.readDouble(offsets[1]);
  return object;
}

P _coordinateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CoordinateModelQueryFilter
    on QueryBuilder<CoordinateModel, CoordinateModel, QFilterCondition> {
  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  latitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  latitudeGreaterThan(
    double value, {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  latitudeLessThan(
    double value, {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  latitudeBetween(
    double lower,
    double upper, {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  longitudeEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  longitudeGreaterThan(
    double value, {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  longitudeLessThan(
    double value, {
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

  QueryBuilder<CoordinateModel, CoordinateModel, QAfterFilterCondition>
  longitudeBetween(
    double lower,
    double upper, {
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
}

extension CoordinateModelQueryObject
    on QueryBuilder<CoordinateModel, CoordinateModel, QFilterCondition> {}
