// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/auth_api.dart';
import 'package:wildlife_api_connection/models/user.dart';

class AuthService {
  var _authApi;

  AuthService() {
    _authApi = AuthApi(
      ApiClient("https://wildlifenl-uu-michi011.apps.cl01.cp.its.uu.nl/auth"),
    );
  }
  AuthService.test(AuthApi authApi) {
    _authApi = authApi;
  }

  Future<Map<String, dynamic>> authenticate(
    String email,
    String? displayNameApp,
  ) async {
    try {
      final response = await _authApi.authenticate(
        displayNameApp,
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
