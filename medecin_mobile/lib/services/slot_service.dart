import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<dynamic>> getSlot(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/slots',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['slot'];
  }

  return [];
}

Future<Object?> postSlot(DateTime date, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/doctor/slot',
    needsToken: true,
    context: context,
    body: jsonEncode({
      'start_date': date.millisecondsSinceEpoch ~/ 1000,
      'end_date':
          (date.add(const Duration(minutes: 30))).millisecondsSinceEpoch ~/ 1000
    }),
  );

  if (response != null) {
    return response;
  }
  return null;
}

Future deleteSlot(String id, BuildContext context) async {
  await httpRequest(
    type: RequestType.delete,
    endpoint: '/doctor/slot/$id',
    needsToken: true,
    context: context,
  );

  return;
}
