// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransferModelCollection on Isar {
  IsarCollection<TransferModel> get transferModels => this.collection();
}

const TransferModelSchema = CollectionSchema(
  name: r'TransferModel',
  id: -7162521379920382670,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'destinataireNom': PropertySchema(
      id: 1,
      name: r'destinataireNom',
      type: IsarType.string,
    ),
    r'expediteurNom': PropertySchema(
      id: 2,
      name: r'expediteurNom',
      type: IsarType.string,
    ),
    r'lotIds': PropertySchema(
      id: 3,
      name: r'lotIds',
      type: IsarType.stringList,
    ),
    r'preuveDocumentUrl': PropertySchema(
      id: 4,
      name: r'preuveDocumentUrl',
      type: IsarType.string,
    ),
    r'signedBy': PropertySchema(
      id: 5,
      name: r'signedBy',
      type: IsarType.stringList,
    ),
    r'syncStatus': PropertySchema(
      id: 6,
      name: r'syncStatus',
      type: IsarType.string,
    ),
    r'transferHashOnChain': PropertySchema(
      id: 7,
      name: r'transferHashOnChain',
      type: IsarType.string,
    ),
    r'transferId': PropertySchema(
      id: 8,
      name: r'transferId',
      type: IsarType.string,
    )
  },
  estimateSize: _transferModelEstimateSize,
  serialize: _transferModelSerialize,
  deserialize: _transferModelDeserialize,
  deserializeProp: _transferModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'transferId': IndexSchema(
      id: -3874495609261714017,
      name: r'transferId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'transferId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _transferModelGetId,
  getLinks: _transferModelGetLinks,
  attach: _transferModelAttach,
  version: '3.1.0+1',
);

int _transferModelEstimateSize(
  TransferModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.destinataireNom.length * 3;
  bytesCount += 3 + object.expediteurNom.length * 3;
  bytesCount += 3 + object.lotIds.length * 3;
  {
    for (var i = 0; i < object.lotIds.length; i++) {
      final value = object.lotIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.preuveDocumentUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.signedBy;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.syncStatus.length * 3;
  {
    final value = object.transferHashOnChain;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.transferId.length * 3;
  return bytesCount;
}

void _transferModelSerialize(
  TransferModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.destinataireNom);
  writer.writeString(offsets[2], object.expediteurNom);
  writer.writeStringList(offsets[3], object.lotIds);
  writer.writeString(offsets[4], object.preuveDocumentUrl);
  writer.writeStringList(offsets[5], object.signedBy);
  writer.writeString(offsets[6], object.syncStatus);
  writer.writeString(offsets[7], object.transferHashOnChain);
  writer.writeString(offsets[8], object.transferId);
}

TransferModel _transferModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransferModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.destinataireNom = reader.readString(offsets[1]);
  object.expediteurNom = reader.readString(offsets[2]);
  object.isarId = id;
  object.lotIds = reader.readStringList(offsets[3]) ?? [];
  object.preuveDocumentUrl = reader.readStringOrNull(offsets[4]);
  object.signedBy = reader.readStringList(offsets[5]);
  object.syncStatus = reader.readString(offsets[6]);
  object.transferHashOnChain = reader.readStringOrNull(offsets[7]);
  object.transferId = reader.readString(offsets[8]);
  return object;
}

P _transferModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _transferModelGetId(TransferModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _transferModelGetLinks(TransferModel object) {
  return [];
}

void _transferModelAttach(
    IsarCollection<dynamic> col, Id id, TransferModel object) {
  object.isarId = id;
}

extension TransferModelByIndex on IsarCollection<TransferModel> {
  Future<TransferModel?> getByTransferId(String transferId) {
    return getByIndex(r'transferId', [transferId]);
  }

  TransferModel? getByTransferIdSync(String transferId) {
    return getByIndexSync(r'transferId', [transferId]);
  }

  Future<bool> deleteByTransferId(String transferId) {
    return deleteByIndex(r'transferId', [transferId]);
  }

  bool deleteByTransferIdSync(String transferId) {
    return deleteByIndexSync(r'transferId', [transferId]);
  }

  Future<List<TransferModel?>> getAllByTransferId(
      List<String> transferIdValues) {
    final values = transferIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'transferId', values);
  }

  List<TransferModel?> getAllByTransferIdSync(List<String> transferIdValues) {
    final values = transferIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'transferId', values);
  }

  Future<int> deleteAllByTransferId(List<String> transferIdValues) {
    final values = transferIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'transferId', values);
  }

  int deleteAllByTransferIdSync(List<String> transferIdValues) {
    final values = transferIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'transferId', values);
  }

  Future<Id> putByTransferId(TransferModel object) {
    return putByIndex(r'transferId', object);
  }

  Id putByTransferIdSync(TransferModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'transferId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTransferId(List<TransferModel> objects) {
    return putAllByIndex(r'transferId', objects);
  }

  List<Id> putAllByTransferIdSync(List<TransferModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'transferId', objects, saveLinks: saveLinks);
  }
}

extension TransferModelQueryWhereSort
    on QueryBuilder<TransferModel, TransferModel, QWhere> {
  QueryBuilder<TransferModel, TransferModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransferModelQueryWhere
    on QueryBuilder<TransferModel, TransferModel, QWhereClause> {
  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause>
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

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause>
      transferIdEqualTo(String transferId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transferId',
        value: [transferId],
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterWhereClause>
      transferIdNotEqualTo(String transferId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transferId',
              lower: [],
              upper: [transferId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transferId',
              lower: [transferId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transferId',
              lower: [transferId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transferId',
              lower: [],
              upper: [transferId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TransferModelQueryFilter
    on QueryBuilder<TransferModel, TransferModel, QFilterCondition> {
  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destinataireNom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinataireNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinataireNom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinataireNom',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      destinataireNomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinataireNom',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expediteurNom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expediteurNom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expediteurNom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expediteurNom',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      expediteurNomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expediteurNom',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lotIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lotIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lotIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lotIds',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lotIds',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      lotIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lotIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preuveDocumentUrl',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preuveDocumentUrl',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preuveDocumentUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preuveDocumentUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preuveDocumentUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preuveDocumentUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      preuveDocumentUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preuveDocumentUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signedBy',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signedBy',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      signedByLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signedBy',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'transferHashOnChain',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'transferHashOnChain',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transferHashOnChain',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transferHashOnChain',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transferHashOnChain',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferHashOnChain',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferHashOnChainIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transferHashOnChain',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transferId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transferId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterFilterCondition>
      transferIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transferId',
        value: '',
      ));
    });
  }
}

extension TransferModelQueryObject
    on QueryBuilder<TransferModel, TransferModel, QFilterCondition> {}

extension TransferModelQueryLinks
    on QueryBuilder<TransferModel, TransferModel, QFilterCondition> {}

extension TransferModelQuerySortBy
    on QueryBuilder<TransferModel, TransferModel, QSortBy> {
  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByDestinataireNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinataireNom', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByDestinataireNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinataireNom', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByExpediteurNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expediteurNom', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByExpediteurNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expediteurNom', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByPreuveDocumentUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preuveDocumentUrl', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByPreuveDocumentUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preuveDocumentUrl', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByTransferHashOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferHashOnChain', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByTransferHashOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferHashOnChain', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> sortByTransferId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      sortByTransferIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.desc);
    });
  }
}

extension TransferModelQuerySortThenBy
    on QueryBuilder<TransferModel, TransferModel, QSortThenBy> {
  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByDestinataireNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinataireNom', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByDestinataireNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinataireNom', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByExpediteurNom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expediteurNom', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByExpediteurNomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expediteurNom', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByPreuveDocumentUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preuveDocumentUrl', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByPreuveDocumentUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preuveDocumentUrl', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByTransferHashOnChain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferHashOnChain', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByTransferHashOnChainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferHashOnChain', Sort.desc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy> thenByTransferId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.asc);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QAfterSortBy>
      thenByTransferIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.desc);
    });
  }
}

extension TransferModelQueryWhereDistinct
    on QueryBuilder<TransferModel, TransferModel, QDistinct> {
  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct>
      distinctByDestinataireNom({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinataireNom',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctByExpediteurNom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expediteurNom',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctByLotIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lotIds');
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct>
      distinctByPreuveDocumentUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preuveDocumentUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctBySignedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signedBy');
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctBySyncStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct>
      distinctByTransferHashOnChain({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transferHashOnChain',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransferModel, TransferModel, QDistinct> distinctByTransferId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transferId', caseSensitive: caseSensitive);
    });
  }
}

extension TransferModelQueryProperty
    on QueryBuilder<TransferModel, TransferModel, QQueryProperty> {
  QueryBuilder<TransferModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<TransferModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TransferModel, String, QQueryOperations>
      destinataireNomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinataireNom');
    });
  }

  QueryBuilder<TransferModel, String, QQueryOperations>
      expediteurNomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expediteurNom');
    });
  }

  QueryBuilder<TransferModel, List<String>, QQueryOperations> lotIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lotIds');
    });
  }

  QueryBuilder<TransferModel, String?, QQueryOperations>
      preuveDocumentUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preuveDocumentUrl');
    });
  }

  QueryBuilder<TransferModel, List<String>?, QQueryOperations>
      signedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signedBy');
    });
  }

  QueryBuilder<TransferModel, String, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<TransferModel, String?, QQueryOperations>
      transferHashOnChainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transferHashOnChain');
    });
  }

  QueryBuilder<TransferModel, String, QQueryOperations> transferIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transferId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransportOrderModelCollection on Isar {
  IsarCollection<TransportOrderModel> get transportOrderModels =>
      this.collection();
}

const TransportOrderModelSchema = CollectionSchema(
  name: r'TransportOrderModel',
  id: -8158668905116395209,
  properties: {
    r'datePickup': PropertySchema(
      id: 0,
      name: r'datePickup',
      type: IsarType.dateTime,
    ),
    r'driverId': PropertySchema(
      id: 1,
      name: r'driverId',
      type: IsarType.string,
    ),
    r'eta': PropertySchema(
      id: 2,
      name: r'eta',
      type: IsarType.dateTime,
    ),
    r'lieuDropoff': PropertySchema(
      id: 3,
      name: r'lieuDropoff',
      type: IsarType.string,
    ),
    r'lieuPickup': PropertySchema(
      id: 4,
      name: r'lieuPickup',
      type: IsarType.string,
    ),
    r'orderId': PropertySchema(
      id: 5,
      name: r'orderId',
      type: IsarType.string,
    ),
    r'statut': PropertySchema(
      id: 6,
      name: r'statut',
      type: IsarType.string,
    ),
    r'transferId': PropertySchema(
      id: 7,
      name: r'transferId',
      type: IsarType.string,
    ),
    r'transporterId': PropertySchema(
      id: 8,
      name: r'transporterId',
      type: IsarType.string,
    ),
    r'vehicleId': PropertySchema(
      id: 9,
      name: r'vehicleId',
      type: IsarType.string,
    )
  },
  estimateSize: _transportOrderModelEstimateSize,
  serialize: _transportOrderModelSerialize,
  deserialize: _transportOrderModelDeserialize,
  deserializeProp: _transportOrderModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'orderId': IndexSchema(
      id: -6176610178429382285,
      name: r'orderId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _transportOrderModelGetId,
  getLinks: _transportOrderModelGetLinks,
  attach: _transportOrderModelAttach,
  version: '3.1.0+1',
);

int _transportOrderModelEstimateSize(
  TransportOrderModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.driverId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.lieuDropoff.length * 3;
  bytesCount += 3 + object.lieuPickup.length * 3;
  bytesCount += 3 + object.orderId.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  bytesCount += 3 + object.transferId.length * 3;
  bytesCount += 3 + object.transporterId.length * 3;
  {
    final value = object.vehicleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _transportOrderModelSerialize(
  TransportOrderModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.datePickup);
  writer.writeString(offsets[1], object.driverId);
  writer.writeDateTime(offsets[2], object.eta);
  writer.writeString(offsets[3], object.lieuDropoff);
  writer.writeString(offsets[4], object.lieuPickup);
  writer.writeString(offsets[5], object.orderId);
  writer.writeString(offsets[6], object.statut);
  writer.writeString(offsets[7], object.transferId);
  writer.writeString(offsets[8], object.transporterId);
  writer.writeString(offsets[9], object.vehicleId);
}

TransportOrderModel _transportOrderModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransportOrderModel();
  object.datePickup = reader.readDateTime(offsets[0]);
  object.driverId = reader.readStringOrNull(offsets[1]);
  object.eta = reader.readDateTimeOrNull(offsets[2]);
  object.isarId = id;
  object.lieuDropoff = reader.readString(offsets[3]);
  object.lieuPickup = reader.readString(offsets[4]);
  object.orderId = reader.readString(offsets[5]);
  object.statut = reader.readString(offsets[6]);
  object.transferId = reader.readString(offsets[7]);
  object.transporterId = reader.readString(offsets[8]);
  object.vehicleId = reader.readStringOrNull(offsets[9]);
  return object;
}

P _transportOrderModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _transportOrderModelGetId(TransportOrderModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _transportOrderModelGetLinks(
    TransportOrderModel object) {
  return [];
}

void _transportOrderModelAttach(
    IsarCollection<dynamic> col, Id id, TransportOrderModel object) {
  object.isarId = id;
}

extension TransportOrderModelByIndex on IsarCollection<TransportOrderModel> {
  Future<TransportOrderModel?> getByOrderId(String orderId) {
    return getByIndex(r'orderId', [orderId]);
  }

  TransportOrderModel? getByOrderIdSync(String orderId) {
    return getByIndexSync(r'orderId', [orderId]);
  }

  Future<bool> deleteByOrderId(String orderId) {
    return deleteByIndex(r'orderId', [orderId]);
  }

  bool deleteByOrderIdSync(String orderId) {
    return deleteByIndexSync(r'orderId', [orderId]);
  }

  Future<List<TransportOrderModel?>> getAllByOrderId(
      List<String> orderIdValues) {
    final values = orderIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'orderId', values);
  }

  List<TransportOrderModel?> getAllByOrderIdSync(List<String> orderIdValues) {
    final values = orderIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'orderId', values);
  }

  Future<int> deleteAllByOrderId(List<String> orderIdValues) {
    final values = orderIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'orderId', values);
  }

  int deleteAllByOrderIdSync(List<String> orderIdValues) {
    final values = orderIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'orderId', values);
  }

  Future<Id> putByOrderId(TransportOrderModel object) {
    return putByIndex(r'orderId', object);
  }

  Id putByOrderIdSync(TransportOrderModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'orderId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOrderId(List<TransportOrderModel> objects) {
    return putAllByIndex(r'orderId', objects);
  }

  List<Id> putAllByOrderIdSync(List<TransportOrderModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'orderId', objects, saveLinks: saveLinks);
  }
}

extension TransportOrderModelQueryWhereSort
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QWhere> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TransportOrderModelQueryWhere
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QWhereClause> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
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

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      orderIdEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderId',
        value: [orderId],
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterWhereClause>
      orderIdNotEqualTo(String orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TransportOrderModelQueryFilter on QueryBuilder<TransportOrderModel,
    TransportOrderModel, QFilterCondition> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      datePickupEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'datePickup',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      datePickupGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'datePickup',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      datePickupLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'datePickup',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      datePickupBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'datePickup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'driverId',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'driverId',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'driverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'driverId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'driverId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      driverIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'driverId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eta',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eta',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      etaBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lieuDropoff',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lieuDropoff',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lieuDropoff',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuDropoff',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuDropoffIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lieuDropoff',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lieuPickup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lieuPickup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lieuPickup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lieuPickup',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      lieuPickupIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lieuPickup',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      orderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statut',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statut',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statut',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statut',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transferId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transferId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transferId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transferId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transferIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transferId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transporterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transporterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transporterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transporterId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      transporterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transporterId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleId',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterFilterCondition>
      vehicleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleId',
        value: '',
      ));
    });
  }
}

extension TransportOrderModelQueryObject on QueryBuilder<TransportOrderModel,
    TransportOrderModel, QFilterCondition> {}

extension TransportOrderModelQueryLinks on QueryBuilder<TransportOrderModel,
    TransportOrderModel, QFilterCondition> {}

extension TransportOrderModelQuerySortBy
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QSortBy> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByDatePickup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePickup', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByDatePickupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePickup', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByDriverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByDriverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByEtaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByLieuDropoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDropoff', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByLieuDropoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDropoff', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByLieuPickup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuPickup', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByLieuPickupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuPickup', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByTransferId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByTransferIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByTransporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transporterId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByTransporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transporterId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      sortByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }
}

extension TransportOrderModelQuerySortThenBy
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QSortThenBy> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByDatePickup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePickup', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByDatePickupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'datePickup', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByDriverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByDriverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByEtaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByLieuDropoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDropoff', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByLieuDropoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuDropoff', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByLieuPickup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuPickup', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByLieuPickupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lieuPickup', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByTransferId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByTransferIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transferId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByTransporterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transporterId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByTransporterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transporterId', Sort.desc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.asc);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QAfterSortBy>
      thenByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleId', Sort.desc);
    });
  }
}

extension TransportOrderModelQueryWhereDistinct
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct> {
  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByDatePickup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'datePickup');
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByDriverId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'driverId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eta');
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByLieuDropoff({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lieuDropoff', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByLieuPickup({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lieuPickup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByOrderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByStatut({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByTransferId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transferId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByTransporterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transporterId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransportOrderModel, TransportOrderModel, QDistinct>
      distinctByVehicleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleId', caseSensitive: caseSensitive);
    });
  }
}

extension TransportOrderModelQueryProperty
    on QueryBuilder<TransportOrderModel, TransportOrderModel, QQueryProperty> {
  QueryBuilder<TransportOrderModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<TransportOrderModel, DateTime, QQueryOperations>
      datePickupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'datePickup');
    });
  }

  QueryBuilder<TransportOrderModel, String?, QQueryOperations>
      driverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'driverId');
    });
  }

  QueryBuilder<TransportOrderModel, DateTime?, QQueryOperations> etaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eta');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations>
      lieuDropoffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lieuDropoff');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations>
      lieuPickupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lieuPickup');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations>
      orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations>
      transferIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transferId');
    });
  }

  QueryBuilder<TransportOrderModel, String, QQueryOperations>
      transporterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transporterId');
    });
  }

  QueryBuilder<TransportOrderModel, String?, QQueryOperations>
      vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleId');
    });
  }
}
