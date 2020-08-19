// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
    hits: json['hits'] == null
        ? null
        : Hits.fromJson(json['hits'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'hits': instance.hits,
    };

Hits _$HitsFromJson(Map<String, dynamic> json) {
  return Hits(
    total: json['total'] == null
        ? null
        : Total.fromJson(json['total'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$HitsToJson(Hits instance) => <String, dynamic>{
      'total': instance.total,
    };

Total _$TotalFromJson(Map<String, dynamic> json) {
  return Total(
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$TotalToJson(Total instance) => <String, dynamic>{
      'value': instance.value,
    };
