// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramRequest _$ProgramRequestFromJson(Map<String, dynamic> json) =>
    ProgramRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      organizationId: json['organizationId'] as String,
      type: $enumDecode(_$ProgramTypeEnumMap, json['type']),
      schoolId: json['schoolId'] as String?,
    );

Map<String, dynamic> _$ProgramRequestToJson(ProgramRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'organizationId': instance.organizationId,
      'type': _$ProgramTypeEnumMap[instance.type]!,
      'schoolId': instance.schoolId,
    };

const _$ProgramTypeEnumMap = {
  ProgramType.DEGREE: 'DEGREE',
  ProgramType.CERTIFICATION: 'CERTIFICATION',
  ProgramType.BOOTCAMP: 'BOOTCAMP',
};

ProgramResponse _$ProgramResponseFromJson(Map<String, dynamic> json) =>
    ProgramResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      organizationId: json['organizationId'] as String,
      type: $enumDecode(_$ProgramTypeEnumMap, json['type']),
      schoolId: json['schoolId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProgramResponseToJson(ProgramResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'organizationId': instance.organizationId,
      'type': _$ProgramTypeEnumMap[instance.type]!,
      'schoolId': instance.schoolId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
