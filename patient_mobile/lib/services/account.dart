import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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

Future deleteAccount(BuildContext context) async {
  await httpRequest(
    type: RequestType.post,
    endpoint: 'auth/delete_account',
    needsToken: true,
    context: context,
  );
}

Future<bool> updatePassword(
    String oldPassword, String password, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: 'auth/update_password',
    needsToken: true,
    body: {"old_password": oldPassword, "new_password": password},
    context: context,
  );
  if (response != null) {
    Logger().i(response);
    return true;
  }
  return false;
}
