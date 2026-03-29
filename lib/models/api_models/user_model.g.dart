// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    CreateUserRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      organizationId: json['organizationId'] as String?,
      schoolId: json['schoolId'] as String?,
    );

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'role': _$RoleEnumMap[instance.role]!,
      'organizationId': instance.organizationId,
      'schoolId': instance.schoolId,
    };

const _$RoleEnumMap = {
  Role.ADMIN: 'ADMIN',
  Role.SCHOOL_ADMIN: 'SCHOOL_ADMIN',
  Role.TEACHER: 'TEACHER',
  Role.STUDENT: 'STUDENT',
};

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  isActive: json['isActive'] as bool,
  organizationId: json['organizationId'] as String?,
  schoolId: json['schoolId'] as String?,
  isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$RoleEnumMap[instance.role]!,
      'isActive': instance.isActive,
      'organizationId': instance.organizationId,
      'schoolId': instance.schoolId,
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
