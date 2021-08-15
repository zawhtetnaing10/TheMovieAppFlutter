// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_actors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActorsResponse _$GetActorsResponseFromJson(Map<String, dynamic> json) =>
    GetActorsResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => ActorVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetActorsResponseToJson(GetActorsResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'results': instance.results,
    };
