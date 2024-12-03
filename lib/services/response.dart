import 'package:flutter/material.dart';
import 'package:wildlife_api_connection/api_client.dart';
import 'package:wildlife_api_connection/response_api.dart';

class ResponseService {
  final _responseApi = ResponseApi(
    ApiClient(
        "https://wildlifenl-uu-michi011.apps.cl01.cp.its.uu.nl/interaction"),
  );

  Future<void> createResponse(
    String interactionId,
    String questionId,
    String answerId,
    String text,
  ) {
    try {
      final response =
          _responseApi.addResponse(interactionId, questionId, answerId, text);
      return response;
    } catch (e) {
      debugPrint("Create response failed: $e");
      throw ("Create response failed: $e");
    }
  }
}
