// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditVO _$CreditVOFromJson(Map<String, dynamic> json) {
  return CreditVO(
    json['adult'] as bool,
    json['gender'] as int,
    json['id'] as int,
    json['known_for_department'] as String,
    json['original_name'] as String,
    (json['popularity'] as num)?.toDouble(),
    json['cast_id'] as int,
    json['character'] as String,
    json['credit_id'] as String,
    json['order'] as int,
    json['name'] as String,
    json['profile_path'] as String,
  );
}

Map<String, dynamic> _$CreditVOToJson(CreditVO instance) => <String, dynamic>{
      'name': instance.name,
      'profile_path': instance.profilePath,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
    };
