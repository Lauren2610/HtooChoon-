import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/otp_screen.dart';
import 'package:htoochoon_flutter/Screens/MainLayout/main_scaffold.dart';
import 'package:htoochoon_flutter/Screens/Onboarding/onboarding_screen.dart';
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
  User? _user;

  String? _userId;
  bool get isLoading => _isLoading;
  String? get accessToken => _accessToken;
  User? get user => _user;

  String? get userId => _userId;

  /// =========================
  /// LOAD USER FROM STORAGE
  /// =========================
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _accessToken = prefs.getString("access_token");

    _user = User(
      id: prefs.getString("id") ?? '',
      email: prefs.getString("email") ?? '',
      googleId: prefs.getString("googleId") ?? '',
      name: prefs.getString("name") ?? '',
      role: prefs.getString("role") ?? '',
      isActive: prefs.getBool("isActive") ?? false,
      isTwoFactorEnabled: prefs.getBool("isTwoFactorEnabled") ?? false,
      twoFactorSecret: prefs.getString("twoFactorSecret") ?? '',
      createdAt:
          DateTime.tryParse(prefs.getString("createdAt") ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(prefs.getString("updatedAt") ?? '') ??
          DateTime.now(),
    );

    notifyListeners();
  }

  Future<void> saveUserToPrefs(User user, {String? accessToken}) async {
    final prefs = await SharedPreferences.getInstance();

    if (accessToken != null) {
      await prefs.setString("access_token", accessToken);
    }

    final dataMap = {
      "id": user.id.toString(),
      "email": user.email ?? '',
      "googleId": user.googleId ?? '',
      "name": user.name ?? '',
      "role": user.role ?? '',
      "isActive": user.isActive ?? false,
      "isTwoFactorEnabled": user.isTwoFactorEnabled ?? false,
      "twoFactorSecret": user.twoFactorSecret ?? '',
      "createdAt": user.createdAt?.toIso8601String() ?? '',
      "updatedAt": user.updatedAt?.toIso8601String() ?? '',
    };

    for (final entry in dataMap.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await prefs.setString(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else {
        print("Skipping unsupported type for key: $key");
      }
    }
  }

  /// =========================
  /// REGISTER
  /// =========================
  Future<RegisterResponse?> register(
    RegisterRequest request,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.register(request);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(email: request.email)),
      );
      notifyListeners();
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

  /// Request OTP without changing loading state (for internal use)
  Future<RequestOtpResponse?> requestOtpSilent(
    RequestOtpRequest request,
  ) async {
    try {
      final response = await apiService.requestOtp(request);
      return response;
    } catch (e) {
      debugPrint("Request OTP Silent Error: $e");
      rethrow;
    }
  }

  /// =========================
  /// VERIFY OTP
  /// =========================
  Future<VerifyOtpResponse?> verifyOtp(
    VerifyOtpRequest request,
    BuildContext context,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await apiService.verifyOtp(request);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
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
    _isLoading = true;
    notifyListeners();
    try {
      print("Auth_provider: login called");

      // Call API
      final loginResponse = await apiService.login(request);

      // Save user and token
      _accessToken = loginResponse.access_token.toString();
      _user = loginResponse.data;
      await saveUserToPrefs(_user!, accessToken: _accessToken);

      _isLoading = false;
      notifyListeners();

      // Navigate to onboarding
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
        );
      }
    } catch (e) {
      debugPrint("Login Error: $e");

      if (e is DioException) {
        final data = e.response?.data;

        String? message;

        if (data is Map) {
          message = data["message"];
        } else if (data is String) {
          message = data;
        }

        print("ERROR MESSAGE: $message");

        if (message != null &&
            message.contains("Email Not verified or user is not active")) {
          print("Email not verified - requesting OTP");

          // Stop loading before navigating
          _isLoading = false;
          notifyListeners();

          try {
            // Request OTP before navigating to OTP screen (silent to avoid loading state changes)
            await requestOtpSilent(
              RequestOtpRequest(email: request.email, action: "VERIFY_EMAIL"),
            );
            print("OTP requested successfully");
          } catch (otpError) {
            print("Failed to request OTP: $otpError");
            // Continue to OTP screen even if request fails (OTP might already be sent)
          }

          if (context.mounted) {
            // Use pushReplacement to prevent going back to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(email: request.email),
              ),
            );
          }
          return;
        }

        _isLoading = false;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message ?? "Login failed")));
        }
      } else {
        _isLoading = false;
        notifyListeners();
      }
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
