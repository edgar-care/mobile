import 'dart:convert';
import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/2fa/device/$id';
  await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  return;
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

Future removeDevice(String id, BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/device/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  return response;
}
