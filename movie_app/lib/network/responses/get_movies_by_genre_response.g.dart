// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_movies_by_genre_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMoviesByGenreResponse _$GetMoviesByGenreResponseFromJson(
    Map<String, dynamic> json) {
  return GetMoviesByGenreResponse(
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : MovieVO.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GetMoviesByGenreResponseToJson(
        GetMoviesByGenreResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
    };
