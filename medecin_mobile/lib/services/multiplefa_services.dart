import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getEnable2fa() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/dashboard/2fa';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['double_auth']['methods'];
  }
  if (response.statusCode != 200) {
    return [];
  }
  return [];
}

Future<int> delete2faMethod(String method, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/dashboard/2fa/$method';
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  return(response.statusCode);
}

Future<List<dynamic>> generateBackupCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/auth/creation_backup_code';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 201) {
    return jsonDecode(response.body)['double_auth'];
  }
  return [];
}

Future enable2FAEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/2fa/method/email';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'method_2fa': 'EMAIL'}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}

Future enable2FAMobile(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/2fa/method/mobile';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'method_2fa': 'MOBILE', "trusted_device_id": id}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}

Future enable2FA3party(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/2fa/method/third_party/generate';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}