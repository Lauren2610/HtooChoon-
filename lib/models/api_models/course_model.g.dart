// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRequest _$CourseRequestFromJson(Map<String, dynamic> json) =>
    CourseRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      organizationId: json['organizationId'] as String,
      type: $enumDecode(_$CourseTypeEnumMap, json['type']),
      campaignId: json['campaignId'] as String?,
      schoolId: json['schoolId'] as String?,
    );

Map<String, dynamic> _$CourseRequestToJson(CourseRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'organizationId': instance.organizationId,
      'type': _$CourseTypeEnumMap[instance.type]!,
      'campaignId': instance.campaignId,
      'schoolId': instance.schoolId,
    };

const _$CourseTypeEnumMap = {
  CourseType.SKILL: 'SKILL',
  CourseType.ACADEMIC: 'ACADEMIC',
  CourseType.TEST_PREP: 'TEST_PREP',
};

CourseResponse _$CourseResponseFromJson(Map<String, dynamic> json) =>
    CourseResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      organizationId: json['organizationId'] as String,
      type: $enumDecode(_$CourseTypeEnumMap, json['type']),
      campaignId: json['campaignId'] as String?,
      schoolId: json['schoolId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CourseResponseToJson(CourseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'organizationId': instance.organizationId,
      'type': _$CourseTypeEnumMap[instance.type]!,
      'campaignId': instance.campaignId,
      'schoolId': instance.schoolId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
