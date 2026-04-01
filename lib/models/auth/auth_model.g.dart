// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) =>
    RegisterResponse(
      message: json['message'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{'message': instance.message, 'userId': instance.userId};

RequestOtpRequest _$RequestOtpRequestFromJson(Map<String, dynamic> json) =>
    RequestOtpRequest(
      email: json['email'] as String,
      action: json['action'] as String,
    );

Map<String, dynamic> _$RequestOtpRequestToJson(RequestOtpRequest instance) =>
    <String, dynamic>{'email': instance.email, 'action': instance.action};

RequestOtpResponse _$RequestOtpResponseFromJson(Map<String, dynamic> json) =>
    RequestOtpResponse(message: json['message'] as String);

Map<String, dynamic> _$RequestOtpResponseToJson(RequestOtpResponse instance) =>
    <String, dynamic>{'message': instance.message};

VerifyOtpRequest _$VerifyOtpRequestFromJson(Map<String, dynamic> json) =>
    VerifyOtpRequest(
      email: json['email'] as String,
      action: json['action'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyOtpRequestToJson(VerifyOtpRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'action': instance.action,
      'otp': instance.otp,
    };

VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    VerifyOtpResponse(message: json['message'] as String);

Map<String, dynamic> _$VerifyOtpResponseToJson(VerifyOtpResponse instance) =>
    <String, dynamic>{'message': instance.message};

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

AccessTokenWrapper _$AccessTokenWrapperFromJson(Map<String, dynamic> json) =>
    AccessTokenWrapper(access_token: json['access_token'] as String);

Map<String, dynamic> _$AccessTokenWrapperToJson(AccessTokenWrapper instance) =>
    <String, dynamic>{'access_token': instance.access_token};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  googleId: json['googleId'] as String?,
  name: json['name'] as String,
  role: json['role'] as String,
  isActive: json['isActive'] as bool,
  isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool,
  twoFactorSecret: json['twoFactorSecret'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'googleId': instance.googleId,
  'name': instance.name,
  'role': instance.role,
  'isActive': instance.isActive,
  'isTwoFactorEnabled': instance.isTwoFactorEnabled,
  'twoFactorSecret': instance.twoFactorSecret,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      access_token: AccessTokenWrapper.fromJson(
        json['access_token'] as Map<String, dynamic>,
      ),
      data: User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'data': instance.data,
    };

ResetPasswordRequest _$ResetPasswordRequestFromJson(
  Map<String, dynamic> json,
) => ResetPasswordRequest(
  email: json['email'] as String,
  action: json['action'] as String,
  otp: json['otp'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$ResetPasswordRequestToJson(
  ResetPasswordRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'action': instance.action,
  'otp': instance.otp,
  'newPassword': instance.newPassword,
};

ResetPasswordResponse _$ResetPasswordResponseFromJson(
  Map<String, dynamic> json,
) => ResetPasswordResponse(message: json['message'] as String);

Map<String, dynamic> _$ResetPasswordResponseToJson(
  ResetPasswordResponse instance,
) => <String, dynamic>{'message': instance.message};

AuthMeResponse _$AuthMeResponseFromJson(Map<String, dynamic> json) =>
    AuthMeResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$AuthMeResponseToJson(AuthMeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'isActive': instance.isActive,
    };
