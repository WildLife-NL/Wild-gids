import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/auth_api.dart';
import 'package:wildlife_api_connection/models/user.dart';

class AuthService {
  final _authApi = AuthApi(
    AppConfig.shared.apiClient,
  );

  Future<Map<String, dynamic>> authenticate(
    String email,
    String? displayNameApp,
  ) async {
    try {
      final response = await _authApi.authenticate(
        displayNameApp ?? "",
        email,
      );

      return Map<String, dynamic>.from(response);
    } catch (e) {
      debugPrint('Authentication failed: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  Future<User> authorize(
    String email,
    String code,
  ) async {
    try {
      final response = await _authApi.authorize(
        email,
        code,
      );

      return response;
    } catch (e) {
      debugPrint('Authorize failed: $e');
      throw Exception('Authorize failed: $e');
    }
  }

  Future<String?> getBearerToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('bearer_token');
    } catch (e) {
      debugPrint('Failed to get bearer token: $e');
      throw Exception('Failed to get bearer token: $e');
    }
  }
}
