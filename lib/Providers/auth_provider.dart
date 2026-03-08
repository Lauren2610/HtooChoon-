import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/models/auth/auth_model.dart';
import '../api/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;

  AuthProvider(this.apiService);

  bool _isLoading = false;
  String? _accessToken;
  String? _userId;

  bool get isLoading => _isLoading;
  String? get accessToken => _accessToken;
  String? get userId => _userId;

  /// =========================
  /// REGISTER
  /// =========================
  Future<RegisterResponse?> register(RegisterRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.register(request);

      return response;
    } catch (e) {
      debugPrint("Register Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// REQUEST OTP
  /// =========================
  Future<RequestOtpResponse?> requestOtp(RequestOtpRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.requestOtp(request);

      return response;
    } catch (e) {
      debugPrint("Request OTP Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// VERIFY OTP
  /// =========================
  Future<VerifyOtpResponse?> verifyOtp(VerifyOtpRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.verifyOtp(request);

      return response;
    } catch (e) {
      debugPrint("Verify OTP Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// LOGIN
  /// =========================
  Future<LoginResponse?> login(LoginRequest request) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.login(request);

      _accessToken = response.access_token;
      _userId = response.userId;

      return response;
    } catch (e) {
      debugPrint("Login Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// RESET PASSWORD
  /// =========================
  Future<ResetPasswordResponse?> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.resetPassword(request);

      return response;
    } catch (e) {
      debugPrint("Reset Password Error: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  void logout() {
    _accessToken = null;
    _userId = null;

    notifyListeners();
  }
}
