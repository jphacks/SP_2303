// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShopCollection on Isar {
  IsarCollection<Shop> get shops => this.collection();
}

const ShopSchema = CollectionSchema(
  name: r'Shop',
  id: -8611931068241789946,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'googlePlaceId': PropertySchema(
      id: 1,
      name: r'googlePlaceId',
      type: IsarType.string,
    ),
    r'shopAddress': PropertySchema(
      id: 2,
      name: r'shopAddress',
      type: IsarType.string,
    ),
    r'shopLatitude': PropertySchema(
      id: 3,
      name: r'shopLatitude',
      type: IsarType.double,
    ),
    r'shopLongitude': PropertySchema(
      id: 4,
      name: r'shopLongitude',
      type: IsarType.double,
    ),
    r'shopMapIconKind': PropertySchema(
      id: 5,
      name: r'shopMapIconKind',
      type: IsarType.string,
    ),
    r'shopName': PropertySchema(
      id: 6,
      name: r'shopName',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wantToGoFlg': PropertySchema(
      id: 8,
      name: r'wantToGoFlg',
      type: IsarType.bool,
    )
  },
  estimateSize: _shopEstimateSize,
  serialize: _shopSerialize,
  deserialize: _shopDeserialize,
  deserializeProp: _shopDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _shopGetId,
  getLinks: _shopGetLinks,
  attach: _shopAttach,
  version: '3.1.0+1',
);

int _shopEstimateSize(
  Shop object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.googlePlaceId.length * 3;
  bytesCount += 3 + object.shopAddress.length * 3;
  bytesCount += 3 + object.shopMapIconKind.length * 3;
  bytesCount += 3 + object.shopName.length * 3;
  return bytesCount;
}

void _shopSerialize(
  Shop object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.googlePlaceId);
  writer.writeString(offsets[2], object.shopAddress);
  writer.writeDouble(offsets[3], object.shopLatitude);
  writer.writeDouble(offsets[4], object.shopLongitude);
  writer.writeString(offsets[5], object.shopMapIconKind);
  writer.writeString(offsets[6], object.shopName);
  writer.writeDateTime(offsets[7], object.updatedAt);
  writer.writeBool(offsets[8], object.wantToGoFlg);
}

Shop _shopDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Shop();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.googlePlaceId = reader.readString(offsets[1]);
  object.id = id;
  object.shopAddress = reader.readString(offsets[2]);
  object.shopLatitude = reader.readDouble(offsets[3]);
  object.shopLongitude = reader.readDouble(offsets[4]);
  object.shopMapIconKind = reader.readString(offsets[5]);
  object.shopName = reader.readString(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  object.wantToGoFlg = reader.readBool(offsets[8]);
  return object;
}

P _shopDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shopGetId(Shop object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shopGetLinks(Shop object) {
  return [];
}

void _shopAttach(IsarCollection<dynamic> col, Id id, Shop object) {
  object.id = id;
}

extension ShopQueryWhereSort on QueryBuilder<Shop, Shop, QWhere> {
  QueryBuilder<Shop, Shop, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShopQueryWhere on QueryBuilder<Shop, Shop, QWhereClause> {
  QueryBuilder<Shop, Shop, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Shop, Shop, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Shop, Shop, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Shop, Shop, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShopQueryFilter on QueryBuilder<Shop, Shop, QFilterCondition> {
  QueryBuilder<Shop, Shop, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Shop, Shop, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Shop, Shop, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'googlePlaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'googlePlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'googlePlaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googlePlaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> googlePlaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'googlePlaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLatitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLatitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLatitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLatitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLongitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLongitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLongitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopLongitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopMapIconKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopMapIconKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopMapIconKind',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopMapIconKind',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopMapIconKindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopMapIconKind',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shopName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shopName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shopName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shopName',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> shopNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shopName',
        value: '',
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Shop, Shop, QAfterFilterCondition> wantToGoFlgEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wantToGoFlg',
        value: value,
      ));
    });
  }
}

extension ShopQueryObject on QueryBuilder<Shop, Shop, QFilterCondition> {}

extension ShopQueryLinks on QueryBuilder<Shop, Shop, QFilterCondition> {}

extension ShopQuerySortBy on QueryBuilder<Shop, Shop, QSortBy> {
  QueryBuilder<Shop, Shop, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByGooglePlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googlePlaceId', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByGooglePlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googlePlaceId', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLatitude', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLatitude', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLongitude', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLongitude', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopMapIconKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopMapIconKind', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopMapIconKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopMapIconKind', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByWantToGoFlg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wantToGoFlg', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> sortByWantToGoFlgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wantToGoFlg', Sort.desc);
    });
  }
}

extension ShopQuerySortThenBy on QueryBuilder<Shop, Shop, QSortThenBy> {
  QueryBuilder<Shop, Shop, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByGooglePlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googlePlaceId', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByGooglePlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googlePlaceId', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopAddress', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLatitude', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLatitude', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLongitude', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopLongitude', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopMapIconKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopMapIconKind', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopMapIconKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopMapIconKind', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByShopNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shopName', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByWantToGoFlg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wantToGoFlg', Sort.asc);
    });
  }

  QueryBuilder<Shop, Shop, QAfterSortBy> thenByWantToGoFlgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wantToGoFlg', Sort.desc);
    });
  }
}

extension ShopQueryWhereDistinct on QueryBuilder<Shop, Shop, QDistinct> {
  QueryBuilder<Shop, Shop, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByGooglePlaceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googlePlaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByShopAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByShopLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopLatitude');
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByShopLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopLongitude');
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByShopMapIconKind(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopMapIconKind',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByShopName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shopName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Shop, Shop, QDistinct> distinctByWantToGoFlg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wantToGoFlg');
    });
  }
}

extension ShopQueryProperty on QueryBuilder<Shop, Shop, QQueryProperty> {
  QueryBuilder<Shop, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Shop, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Shop, String, QQueryOperations> googlePlaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googlePlaceId');
    });
  }

  QueryBuilder<Shop, String, QQueryOperations> shopAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopAddress');
    });
  }

  QueryBuilder<Shop, double, QQueryOperations> shopLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopLatitude');
    });
  }

  QueryBuilder<Shop, double, QQueryOperations> shopLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopLongitude');
    });
  }

  QueryBuilder<Shop, String, QQueryOperations> shopMapIconKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopMapIconKind');
    });
  }

  QueryBuilder<Shop, String, QQueryOperations> shopNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shopName');
    });
  }

  QueryBuilder<Shop, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Shop, bool, QQueryOperations> wantToGoFlgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wantToGoFlg');
    });
  }
}
