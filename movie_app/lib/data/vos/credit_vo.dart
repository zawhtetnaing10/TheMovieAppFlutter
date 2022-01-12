import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:movie_app/persistence/hive_constants.dart';

import 'base_actor_vo.dart';

part 'credit_vo.g.dart';

@JsonSerializable()
@HiveType(typeId: HIVE_TYPE_ID_CREDIT_VO, adapterName: "CreditVOAdapter")
class CreditVO extends BaseActorVO {
  @JsonKey(name: "adult")
  @HiveField(0)
  bool? adult;
  @JsonKey(name: "gender")
  @HiveField(1)
  int? gender;
  @JsonKey(name: "id")
  @HiveField(2)
  int id;
  @JsonKey(name: "known_for_department")
  @HiveField(3)
  String? knownForDepartment;
  @JsonKey(name: "original_name")
  @HiveField(4)
  String? originalName;
  @JsonKey(name: "popularity")
  @HiveField(5)
  double? popularity;
  @JsonKey(name: "cast_id")
  @HiveField(6)
  int? castId;
  @JsonKey(name: "character")
  @HiveField(7)
  String? character;
  @JsonKey(name: "credit_id")
  @HiveField(8)
  String? creditId;
  @JsonKey(name: "order")
  @HiveField(9)
  int? order;

  CreditVO(
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.originalName,
    this.popularity,
    this.castId,
    this.character,
    this.creditId,
    this.order,
    String? name,
    String? profilePath,
  ) : super(name, profilePath);

  factory CreditVO.fromJson(Map<String, dynamic> json) =>
      _$CreditVOFromJson(json);

  Map<String, dynamic> toJson() => _$CreditVOToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditVO &&
          runtimeType == other.runtimeType &&
          adult == other.adult &&
          gender == other.gender &&
          id == other.id &&
          knownForDepartment == other.knownForDepartment &&
          originalName == other.originalName &&
          popularity == other.popularity &&
          castId == other.castId &&
          character == other.character &&
          creditId == other.creditId &&
          order == other.order;

  @override
  int get hashCode =>
      adult.hashCode ^
      gender.hashCode ^
      id.hashCode ^
      knownForDepartment.hashCode ^
      originalName.hashCode ^
      popularity.hashCode ^
      castId.hashCode ^
      character.hashCode ^
      creditId.hashCode ^
      order.hashCode;

  bool isActor() {
    return knownForDepartment == KNOWN_FOR_DEPARTMENT_ACTING;
  }

  bool isCreator() {
    return knownForDepartment != KNOWN_FOR_DEPARTMENT_ACTING;
  }
}

const String KNOWN_FOR_DEPARTMENT_ACTING = "Acting";
