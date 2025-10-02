// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiaryEntityCollection on Isar {
  IsarCollection<DiaryEntity> get diaryEntitys => this.collection();
}

const DiaryEntitySchema = CollectionSchema(
  name: r'DiaryEntity',
  id: 3606339010430372336,
  properties: {},

  estimateSize: _diaryEntityEstimateSize,
  serialize: _diaryEntitySerialize,
  deserialize: _diaryEntityDeserialize,
  deserializeProp: _diaryEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _diaryEntityGetId,
  getLinks: _diaryEntityGetLinks,
  attach: _diaryEntityAttach,
  version: '3.3.0-dev.3',
);

int _diaryEntityEstimateSize(
  DiaryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _diaryEntitySerialize(
  DiaryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {}
DiaryEntity _diaryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiaryEntity();
  object.id = id;
  return object;
}

P _diaryEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diaryEntityGetId(DiaryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _diaryEntityGetLinks(DiaryEntity object) {
  return [];
}

void _diaryEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  DiaryEntity object,
) {
  object.id = id;
}

extension DiaryEntityQueryWhereSort
    on QueryBuilder<DiaryEntity, DiaryEntity, QWhere> {
  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiaryEntityQueryWhere
    on QueryBuilder<DiaryEntity, DiaryEntity, QWhereClause> {
  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DiaryEntityQueryFilter
    on QueryBuilder<DiaryEntity, DiaryEntity, QFilterCondition> {
  QueryBuilder<DiaryEntity, DiaryEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DiaryEntityQueryObject
    on QueryBuilder<DiaryEntity, DiaryEntity, QFilterCondition> {}

extension DiaryEntityQueryLinks
    on QueryBuilder<DiaryEntity, DiaryEntity, QFilterCondition> {}

extension DiaryEntityQuerySortBy
    on QueryBuilder<DiaryEntity, DiaryEntity, QSortBy> {}

extension DiaryEntityQuerySortThenBy
    on QueryBuilder<DiaryEntity, DiaryEntity, QSortThenBy> {
  QueryBuilder<DiaryEntity, DiaryEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiaryEntity, DiaryEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DiaryEntityQueryWhereDistinct
    on QueryBuilder<DiaryEntity, DiaryEntity, QDistinct> {}

extension DiaryEntityQueryProperty
    on QueryBuilder<DiaryEntity, DiaryEntity, QQueryProperty> {
  QueryBuilder<DiaryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
