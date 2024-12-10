import 'package:flutter/material.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/interaction_api.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/location.dart';

class InteractionService {
  final _interactionApi = InteractionApi(
    AppConfig.shared.apiClient,
  );

  Future<Interaction> createInteraction(
    String description,
    Location location,
    String speciesId,
    int typeId,
  ) {
    try {
      final response =
          _interactionApi.create(description, location, speciesId, typeId);
      return response;
    } catch (e) {
      debugPrint("Get all interation types failed: $e");
      throw ("Get all interaction types failed: $e");
    }
  }
}
