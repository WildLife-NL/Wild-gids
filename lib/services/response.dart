import 'package:flutter/material.dart';
import 'package:wildgids/config/app_config.dart';
import 'package:wildlife_api_connection/response_api.dart';

class ResponseService {
  final _responseApi = ResponseApi(
    AppConfig.shared.apiClient,
  );

  Future<void> createResponse(
    String interactionId,
    String questionId,
    String answerId,
    String text,
  ) {
    try {
      return _responseApi.addResponse(interactionId, questionId, answerId, text);
    } catch (e) {
      debugPrint("Create response failed: $e");
      throw ("Create response failed: $e");
    }
  }
}
