import 'package:flutter/material.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/models/species.dart';
import 'package:wildlife_api_connection/species_api.dart';

class SpeciesService {
  final _speciesApi = SpeciesApi(
    AppConfig.shared.apiClient,
  );

  Future<List<Species>> getAllSpecies() {
    try {
      return _speciesApi.getAllSpecies();
    } catch (e) {
      debugPrint("Get all species failed: $e");
      throw ("Get all species failed: $e");
    }
  }
}