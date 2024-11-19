import 'package:edgar_pro/services/request.dart';
import 'package:flutter/material.dart';

Future<List<dynamic>> getAllDevices(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/dashboard/devices',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['devices'];
  }
  return [];
}

Future addTrustDevices(String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/dashboard/2fa/device/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response;
  }
  return [];
}

Future removeTrustDevice(String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.delete,
    endpoint: '/dashboard/2fa/device/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return;
  }
}

Future<List<dynamic>> getTrustedDevices(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/dashboard/2fa/devices',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['devices'];
  }
  return [];
}

Future removeDevice(String id, BuildContext context) async {
  await httpRequest(
    type: RequestType.delete,
    endpoint: '/dashboard/device/$id',
    needsToken: true,
    context: context,
  );

  return;
}

Future removeTrustDevice(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/2fa/device/$id';
  await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
}

Future<List<dynamic>> getTrustedDevices() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/2fa/devices';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['devices'];
  }
  return [];
}

Future removeDevice(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/device/$id';
  await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
}
