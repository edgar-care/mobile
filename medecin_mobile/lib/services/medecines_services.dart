import 'package:flutter/material.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<Map<String, dynamic>>> getMedecines(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/medicine',
    needsToken: true,
    context: context,
  );
  if (response != null) {
    return List<Map<String, dynamic>>.from(response["medicament"]);
  } else {
    return [];
  }
}
