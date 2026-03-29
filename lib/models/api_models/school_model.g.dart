// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchoolRequest _$SchoolRequestFromJson(Map<String, dynamic> json) =>
    SchoolRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$SchoolRequestToJson(SchoolRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
    };

UpdateSchoolRequest _$UpdateSchoolRequestFromJson(Map<String, dynamic> json) =>
    UpdateSchoolRequest(
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UpdateSchoolRequestToJson(
  UpdateSchoolRequest instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'email': ?instance.email,
  'address': ?instance.address,
};

SchoolResponse _$SchoolResponseFromJson(Map<String, dynamic> json) =>
    SchoolResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SchoolResponseToJson(SchoolResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
