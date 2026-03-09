import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/otp_screen.dart';
import 'package:htoochoon_flutter/models/auth/auth_model.dart';
import '../api/api_service.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService apiService;

  AuthProvider(this.apiService) {
    loadUserFromPrefs();
  }

  bool _isLoading = false;
  String? _accessToken;
  UserResponse? _user;
  String? _userId;
  bool get isLoading => _isLoading;
  String? get accessToken => _accessToken;
  UserResponse? get user => _user;
  String? get userId => _userId;

  /// =========================
  /// LOAD USER FROM STORAGE
  /// =========================
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = prefs.getString("access_token");
    final userJson = prefs.getString("user");

    if (userJson != null) {
      _user = UserResponse.fromJson(jsonDecode(userJson));
    }

    notifyListeners();
  }

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
  Future<void> login(LoginRequest request, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final loginResponse = await apiService.login(request);

      _accessToken = loginResponse.access_token;
      _userId = loginResponse.userId;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("access_token", _accessToken!);
      await prefs.setString("userId", _userId!);

      /// fetch user profile
      final user = await apiService.fetchMe();

      _user = user;

      await prefs.setString("user", jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint("Login Error: $e");
      if (e.toString().contains("Email Not verified")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => OtpScreen(email: request.email)),
        );
      }
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
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove("access_token");
      await prefs.remove("user");

      _accessToken = null;
      _userId = null;

      notifyListeners();
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }
}
