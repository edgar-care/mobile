import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<dynamic>> getAllDoctor(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctors',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return jsonDecode(response)['Doctors'];
  }
  return [];
}
