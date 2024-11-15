import 'package:flutter/material.dart';
import 'package:edgar_pro/services/request.dart';

Future<Map<String, dynamic>> getEnable2fa(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/dashboard/2fa',
    needsToken: true,
    context: context,
  );
  if (response != null) {
    return response['double_auth'];
  }
  return {};
}

Future<int> delete2faMethod(String method, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.delete,
    endpoint: '/dashboard/2fa/$method',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return 200;
  }
  return 0;
}

Future<List<dynamic>> generateBackupCode(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/auth/creation_backup_code',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['double_auth'];
  }
  return [];
}

Future enable2FAEmail(BuildContext context) async {
  await httpRequest(
    type: RequestType.post,
    endpoint: '/2fa/method/email',
    needsToken: true,
    body: {'method_2fa': 'EMAIL'},
    context: context,
  );

  return;
}

Future enable2FAMobile(String id, BuildContext context) async {
  await httpRequest(
    type: RequestType.post,
    endpoint: '/2fa/method/mobile',
    needsToken: true,
    body: {'method_2fa': 'MOBILE', "trusted_device_id": id},
    context: context,
  );

  return;
}

Future<Map<String, dynamic>> enable2FA3party(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/2fa/method/third_party',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response;
  }
  return {};
}

Future<Map<String, dynamic>> checkTierAppCode(
    String code, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/2fa/method/third_party',
    needsToken: true,
    body: {'token': code},
    context: context,
  );

  if (response != null) {
    return response;
  }
  return {};
}
