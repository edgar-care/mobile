import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';

Future<List<Map<String, dynamic>>> getMedecines(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'medicine',
  );

  if (response != null) {
    return List<Map<String, dynamic>>.from(response["medicament"]);
  } else {
    return [];
  }
}
