import 'package:edgar_app/services/request.dart';
import "package:flutter/material.dart";

Future<Map<String, dynamic>?> getAppointement(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'patient/appointments',
    context: context,
    needsToken: true,
  );

  if (response != null) {
    return response;
  } else {
    return null;
  }
}
