// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationRequest _$OrganizationRequestFromJson(Map<String, dynamic> json) =>
    OrganizationRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$OrganizationRequestToJson(
  OrganizationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
};

OrganizationResponse _$OrganizationResponseFromJson(
  Map<String, dynamic> json,
) => OrganizationResponse(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  description: json['description'] as String?,
  logoUrl: json['logoUrl'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrganizationResponseToJson(
  OrganizationResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
