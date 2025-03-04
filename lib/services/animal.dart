import 'package:flutter/foundation.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/models/animal_tracking.dart';
import 'package:wildlife_api_connection/animal_api.dart';

class AnimalService {
  final _animalApi = AnimalApi(
    AppConfig.shared.apiClient,
  );

  Future<List<AnimalTracking>> getAllAnimalTrackings() async {
    try {
      return await _animalApi.getAllAnimalTrackings();
    } catch (e) {
      debugPrint("Get all animal trackings failed: $e");
      throw ("Get all animal trackings failed: $e");
    }
  }
}
