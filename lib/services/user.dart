import 'package:flutter/foundation.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/models/user.dart';
import 'package:wildlife_api_connection/profile_api.dart';

class UserService {
  final _profileApi = ProfileApi(
    AppConfig.shared.apiClient,
  );

  Future<User> getMyProfile() async {
    try {
      final response = await _profileApi.getMyProfile();
      return response;
    } catch (e) {
      debugPrint("Get my profile failed: $e");
      throw ("Get my profile failed: $e");
    }
  }

  Future<User> updateProfile(String name) async {
    try {
      final response = await _profileApi.updateProfile(name);
      return response;
    } catch (e) {
      debugPrint("Update my profile failed: $e");
      throw Exception("Update my profile failed: $e");
    }
  }
}
