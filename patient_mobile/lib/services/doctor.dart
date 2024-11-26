import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';

Future<List<dynamic>> getAllDoctor(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'doctors',
    context: context,
  );

  if (response != null) {
    return response["Doctors"];
  } else {
    return [];
  }
}

Future<dynamic> getDoctorById(BuildContext context, String id) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'doctor/$id',
    context: context,
  );

  if (response != null) {
    return response["Doctors"];
  } else {
    return null;
  }
}
