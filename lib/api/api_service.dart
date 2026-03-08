import 'package:dio/dio.dart';
import 'package:htoochoon_flutter/models/auth/auth_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  /// REGISTER
  @POST("/auth/register")
  Future<RegisterResponse> register(@Body() RegisterRequest body);

  /// REQUEST OTP
  @POST("/auth/request-otp")
  Future<RequestOtpResponse> requestOtp(@Body() RequestOtpRequest request);

  /// VERIFY OTP
  @POST("/auth/verify-otp")
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  /// LOGIN
  @POST("/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// RESET PASSWORD
  @POST("/auth/reset-password")
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequest request,
  );
}
