import 'package:flutter/material.dart';
import 'package:edgar_app/services/request.dart';

Future<Map<String, dynamic>> getEnable2fa(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'dashboard/2fa',
    needsToken: true,
  );

  if (response != null) {
    return response['double_auth'];
  } else {
    return {};
  }
}

Future<int> delete2faMethod(String method, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.delete,
    endpoint: 'dashboard/2fa/$method',
    needsToken: true,
  );

  if (response != null) {
    return 200;
  } else {
    return 400;
  }
}

Future<List<dynamic>> generateBackupCode(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'auth/creation_backup_code',
    needsToken: true,
  );

  if (response != null) {
    return response['double_auth'];
  } else {
    return [];
  }
}

Future enable2FAEmail(BuildContext context) async {
  await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: '2fa/method/email',
    needsToken: true,
    body: {'method_2fa': 'EMAIL'},
  );
}

Future enable2FAMobile(String id, BuildContext context) async {
  await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: '2fa/method/mobile',
    needsToken: true,
    body: {'method_2fa': 'MOBILE', "trusted_device_id": id},
  );

  return;
}

Future<Map<String, dynamic>> enable2FA3party(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: '2fa/method/third_party',
    needsToken: true,
    body: {'method_2fa': 'THIRD_PARTY'},
  );

  if (response != null) {
    return response;
  } else {
    return {};
  }
}

Future<Map<String, dynamic>> checkTierAppCode(
    String code, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: '2fa/method/third_party',
    needsToken: true,
    body: {'token': code},
  );

  if (response != null) {
    return response;
  } else {
    return {};
  }
}
