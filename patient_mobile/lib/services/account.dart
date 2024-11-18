import 'dart:convert';
import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';

Future disableAccount(BuildContext context) async {
  await httpRequest(
    type: RequestType.put,
    endpoint: 'auth/disable_account',
    needsToken: true,
    context: context,
  );
}

Future enableAccount(BuildContext context) async {
  await httpRequest(
    type: RequestType.put,
    endpoint: 'auth/enable_account',
    needsToken: true,
    context: context,
  );
}

Future resetPassword(String password, BuildContext context) async {
  final response = await httpRequest(
      type: RequestType.post,
      endpoint: 'auth/reset_password',
      needsToken: true,
      body: {"new_password": password},
      context: context);
  if (response.body != null) {
    return jsonDecode(response.body)['devices'];
  }
  return response;
}
