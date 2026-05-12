// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQueueItemCollection on Isar {
  IsarCollection<QueueItem> get queueItems => this.collection();
}

const QueueItemSchema = CollectionSchema(
  name: r'QueueItem',
  id: 8159347730612039329,
  properties: {
    r'dateCreation': PropertySchema(
      id: 0,
      name: r'dateCreation',
      type: IsarType.dateTime,
    ),
    r'mediaRefs': PropertySchema(
      id: 1,
      name: r'mediaRefs',
      type: IsarType.stringList,
    ),
    r'payloadRef': PropertySchema(
      id: 2,
      name: r'payloadRef',
      type: IsarType.string,
    ),
    r'payloadType': PropertySchema(
      id: 3,
      name: r'payloadType',
      type: IsarType.string,
    ),
    r'queueId': PropertySchema(id: 4, name: r'queueId', type: IsarType.string),
    r'statut': PropertySchema(id: 5, name: r'statut', type: IsarType.string),
    r'tentatives': PropertySchema(
      id: 6,
      name: r'tentatives',
      type: IsarType.long,
    ),
  },
  estimateSize: _queueItemEstimateSize,
  serialize: _queueItemSerialize,
  deserialize: _queueItemDeserialize,
  deserializeProp: _queueItemDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'queueId': IndexSchema(
      id: -3743451411909378321,
      name: r'queueId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'queueId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'statut': IndexSchema(
      id: 898685416201145331,
      name: r'statut',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statut',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _queueItemGetId,
  getLinks: _queueItemGetLinks,
  attach: _queueItemAttach,
  version: '3.1.0+1',
);

int _queueItemEstimateSize(
  QueueItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mediaRefs.length * 3;
  {
    for (var i = 0; i < object.mediaRefs.length; i++) {
      final value = object.mediaRefs[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.payloadRef.length * 3;
  bytesCount += 3 + object.payloadType.length * 3;
  bytesCount += 3 + object.queueId.length * 3;
  bytesCount += 3 + object.statut.length * 3;
  return bytesCount;
}

void _queueItemSerialize(
  QueueItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dateCreation);
  writer.writeStringList(offsets[1], object.mediaRefs);
  writer.writeString(offsets[2], object.payloadRef);
  writer.writeString(offsets[3], object.payloadType);
  writer.writeString(offsets[4], object.queueId);
  writer.writeString(offsets[5], object.statut);
  writer.writeLong(offsets[6], object.tentatives);
}

QueueItem _queueItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QueueItem();
  object.dateCreation = reader.readDateTime(offsets[0]);
  object.isarId = id;
  object.mediaRefs = reader.readStringList(offsets[1]) ?? [];
  object.payloadRef = reader.readString(offsets[2]);
  object.payloadType = reader.readString(offsets[3]);
  object.queueId = reader.readString(offsets[4]);
  object.statut = reader.readString(offsets[5]);
  object.tentatives = reader.readLong(offsets[6]);
  return object;
}

P _queueItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _queueItemGetId(QueueItem object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _queueItemGetLinks(QueueItem object) {
  return [];
}

void _queueItemAttach(IsarCollection<dynamic> col, Id id, QueueItem object) {
  object.isarId = id;
}

extension QueueItemByIndex on IsarCollection<QueueItem> {
  Future<QueueItem?> getByQueueId(String queueId) {
    return getByIndex(r'queueId', [queueId]);
  }

  QueueItem? getByQueueIdSync(String queueId) {
    return getByIndexSync(r'queueId', [queueId]);
  }

  Future<bool> deleteByQueueId(String queueId) {
    return deleteByIndex(r'queueId', [queueId]);
  }

  bool deleteByQueueIdSync(String queueId) {
    return deleteByIndexSync(r'queueId', [queueId]);
  }

  Future<List<QueueItem?>> getAllByQueueId(List<String> queueIdValues) {
    final values = queueIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'queueId', values);
  }

  List<QueueItem?> getAllByQueueIdSync(List<String> queueIdValues) {
    final values = queueIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'queueId', values);
  }

  Future<int> deleteAllByQueueId(List<String> queueIdValues) {
    final values = queueIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'queueId', values);
  }

  int deleteAllByQueueIdSync(List<String> queueIdValues) {
    final values = queueIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'queueId', values);
  }

  Future<Id> putByQueueId(QueueItem object) {
    return putByIndex(r'queueId', object);
  }

  Id putByQueueIdSync(QueueItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'queueId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQueueId(List<QueueItem> objects) {
    return putAllByIndex(r'queueId', objects);
  }

  List<Id> putAllByQueueIdSync(
    List<QueueItem> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'queueId', objects, saveLinks: saveLinks);
  }
}

extension QueueItemQueryWhereSort
    on QueryBuilder<QueueItem, QueueItem, QWhere> {
  QueryBuilder<QueueItem, QueueItem, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QueueItemQueryWhere
    on QueryBuilder<QueueItem, QueueItem, QWhereClause> {
  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> isarIdEqualTo(
    Id isarId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> isarIdNotEqualTo(
    Id isarId,
  ) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> isarIdGreaterThan(
    Id isarId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> isarIdLessThan(
    Id isarId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> queueIdEqualTo(
    String queueId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'queueId', value: [queueId]),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> queueIdNotEqualTo(
    String queueId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'queueId',
                lower: [],
                upper: [queueId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'queueId',
                lower: [queueId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'queueId',
                lower: [queueId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'queueId',
                lower: [],
                upper: [queueId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> statutEqualTo(
    String statut,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'statut', value: [statut]),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterWhereClause> statutNotEqualTo(
    String statut,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statut',
                lower: [],
                upper: [statut],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statut',
                lower: [statut],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statut',
                lower: [statut],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statut',
                lower: [],
                upper: [statut],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension QueueItemQueryFilter
    on QueryBuilder<QueueItem, QueueItem, QFilterCondition> {
  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> dateCreationEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateCreation', value: value),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  dateCreationGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateCreation',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  dateCreationLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateCreation',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> dateCreationBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateCreation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> isarIdEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaRefs',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mediaRefs',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mediaRefs',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaRefs', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mediaRefs', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mediaRefs', length, true, length, true);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> mediaRefsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mediaRefs', 0, true, 0, true);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mediaRefs', 0, false, 999999, true);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mediaRefs', 0, true, length, include);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'mediaRefs', length, include, 999999, true);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  mediaRefsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mediaRefs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadRefGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadRef',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadRefStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'payloadRef',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadRefMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'payloadRef',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadRef', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadRef', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'payloadType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'payloadType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> payloadTypeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'payloadType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'payloadType', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  payloadTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'payloadType', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'queueId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'queueId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'queueId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> queueIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'queueId', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  queueIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'queueId', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutGreaterThan(
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutLessThan(
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutBetween(
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'statut', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> statutIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'statut', value: ''),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> tentativesEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tentatives', value: value),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition>
  tentativesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tentatives',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> tentativesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tentatives',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterFilterCondition> tentativesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tentatives',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension QueueItemQueryObject
    on QueryBuilder<QueueItem, QueueItem, QFilterCondition> {}

extension QueueItemQueryLinks
    on QueryBuilder<QueueItem, QueueItem, QFilterCondition> {}

extension QueueItemQuerySortBy on QueryBuilder<QueueItem, QueueItem, QSortBy> {
  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByDateCreation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreation', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByDateCreationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreation', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByPayloadRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadRef', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByPayloadRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadRef', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByPayloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadType', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByPayloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadType', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByQueueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueId', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByQueueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueId', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByTentatives() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tentatives', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> sortByTentativesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tentatives', Sort.desc);
    });
  }
}

extension QueueItemQuerySortThenBy
    on QueryBuilder<QueueItem, QueueItem, QSortThenBy> {
  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByDateCreation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreation', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByDateCreationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateCreation', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByPayloadRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadRef', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByPayloadRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadRef', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByPayloadType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadType', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByPayloadTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadType', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByQueueId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueId', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByQueueIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queueId', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByStatut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByStatutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statut', Sort.desc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByTentatives() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tentatives', Sort.asc);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QAfterSortBy> thenByTentativesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tentatives', Sort.desc);
    });
  }
}

extension QueueItemQueryWhereDistinct
    on QueryBuilder<QueueItem, QueueItem, QDistinct> {
  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByDateCreation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateCreation');
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByMediaRefs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaRefs');
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByPayloadRef({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByPayloadType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByQueueId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queueId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByStatut({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statut', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QueueItem, QueueItem, QDistinct> distinctByTentatives() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tentatives');
    });
  }
}

extension QueueItemQueryProperty
    on QueryBuilder<QueueItem, QueueItem, QQueryProperty> {
  QueryBuilder<QueueItem, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<QueueItem, DateTime, QQueryOperations> dateCreationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateCreation');
    });
  }

  QueryBuilder<QueueItem, List<String>, QQueryOperations> mediaRefsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaRefs');
    });
  }

  QueryBuilder<QueueItem, String, QQueryOperations> payloadRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadRef');
    });
  }

  QueryBuilder<QueueItem, String, QQueryOperations> payloadTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadType');
    });
  }

  QueryBuilder<QueueItem, String, QQueryOperations> queueIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queueId');
    });
  }

  QueryBuilder<QueueItem, String, QQueryOperations> statutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statut');
    });
  }

  QueryBuilder<QueueItem, int, QQueryOperations> tentativesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tentatives');
    });
  }
}
