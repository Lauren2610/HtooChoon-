import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

/// ============================
/// REGISTER REQUEST
/// ============================
@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String name;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

/// ============================
/// REGISTER RESPONSE
/// ============================
@JsonSerializable()
class RegisterResponse {
  final String message;
  final String userId;

  RegisterResponse({required this.message, required this.userId});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}

/// ============================
/// REQUEST OTP REQUEST
/// ============================
@JsonSerializable()
class RequestOtpRequest {
  final String email;
  final String action;

  RequestOtpRequest({required this.email, required this.action});

  factory RequestOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpRequestToJson(this);
}

/// ============================
/// REQUEST OTP RESPONSE
/// ============================
@JsonSerializable()
class RequestOtpResponse {
  final String message;

  RequestOtpResponse({required this.message});

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$RequestOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpResponseToJson(this);
}

/// ============================
/// VERIFY OTP REQUEST
/// ============================
@JsonSerializable()
class VerifyOtpRequest {
  final String email;
  final String action;
  final String otp;

  VerifyOtpRequest({
    required this.email,
    required this.action,
    required this.otp,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

/// ============================
/// VERIFY OTP RESPONSE
/// ============================
@JsonSerializable()
class VerifyOtpResponse {
  final String message;

  VerifyOtpResponse({required this.message});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

/// ================= LOGIN REQUEST =================
@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

/// ================= ACCESS TOKEN WRAPPER =================
@JsonSerializable()
class AccessTokenWrapper {
  final String access_token;

  AccessTokenWrapper({required this.access_token});

  factory AccessTokenWrapper.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenWrapperToJson(this);
}

/// ================= USER MODEL =================
@JsonSerializable()
class User {
  final String id;
  final String email;
  final String? googleId;
  final String name;
  final String role;
  final bool isActive;
  final bool isTwoFactorEnabled;
  final String? twoFactorSecret;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.googleId,
    required this.name,
    required this.role,
    required this.isActive,
    required this.isTwoFactorEnabled,
    this.twoFactorSecret,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/// ================= LOGIN RESPONSE =================
@JsonSerializable()
class LoginResponse {
  final AccessTokenWrapper access_token;
  final User data;

  LoginResponse({required this.access_token, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// ============================
/// RESET PASSWORD REQUEST
/// ============================
@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String action;
  final String otp;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.action,
    required this.otp,
    required this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}

/// ============================
/// RESET PASSWORD RESPONSE
/// ============================
@JsonSerializable()
class ResetPasswordResponse {
  final String message;

  ResetPasswordResponse({required this.message});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseToJson(this);
}

/// ============================
/// AUTHME RESPONSE
/// ============================

@JsonSerializable()
class AuthMeResponse {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool isActive;

  AuthMeResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
  });

  factory AuthMeResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthMeResponseToJson(this);
}
