// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_credits_by_movie_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCreditsByMovieResponse _$GetCreditsByMovieResponseFromJson(
    Map<String, dynamic> json) {
  return GetCreditsByMovieResponse(
    json['id'] as int,
    (json['cast'] as List)
        ?.map((e) =>
            e == null ? null : CreditVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetCreditsByMovieResponseToJson(
        GetCreditsByMovieResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
    };
