import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';

Future<String> initiateDiagnostic(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'diagnostic/initiate',
    needsToken: true,
  );
  if (response.statusCode != null) {
    return response["sessionId"];
  } else {
    return "";
  }
}

Future<Map<String, dynamic>> getDiagnostic(
    String sessionId, String sentence, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'diagnostic/diagnose',
    needsToken: true,
    body: {"id": sessionId, "sentence": sentence},
  );

  if (response != null) {
    return response;
  } else {
    return {};
  }
}
