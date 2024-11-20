// ignore_for_file: use_build_context_synchronously

import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:edgar_pro/services/request.dart';

Map<String, dynamic> diagnosticInfo = {};

void mapperDiagnostic(Map<String, dynamic> data) {
  diagnosticInfo = {
    "fiability": data['fiability'] ?? 0,
    "diseases": data['diseases'] ?? [],
    "symptoms": data['symptoms'] ?? [],
    "logs": data['logs'] ?? [],
    "session_id": data['session_id'] ?? '',
  };
}

Future<Map<String, dynamic>> getSummary(String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/diagnostic/summary/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    mapperDiagnostic(response);
    return diagnosticInfo;
  }

  return {};
}

Future<void> postDiagValidation(BuildContext context, String id,
    bool validation, String reason, String health) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/doctor/diagnostic/$id',
    needsToken: true,
    context: context,
    body: {
      if (reason != '') 'reason': reason,
      'validation': validation,
      if (health != '') "health_method": health
    },
  );

  if (response != null) {
    const TopInfoSnackBar(message: "Réponse envoyée avec succes").show(context);
  } else {
    const TopErrorSnackBar(message: "Une erreur est survenue").show(context);
  }
}
