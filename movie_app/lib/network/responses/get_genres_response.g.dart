// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_genres_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGenresResponse _$GetGenresResponseFromJson(Map<String, dynamic> json) {
  return GetGenresResponse(
    genres: (json['genres'] as List)
        ?.map((e) =>
            e == null ? null : GenreVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetGenresResponseToJson(GetGenresResponse instance) =>
    <String, dynamic>{
      'genres': instance.genres,
    };
