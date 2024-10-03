import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getEnable2fa() async {
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
    return jsonDecode(response.body)['double_auth'];
  }
  return {};
}

Future<int> delete2faMethod(String method) async {
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
  return response.statusCode;
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
  await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'method_2fa': 'EMAIL'}),
  );
}

Future enable2FAMobile(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/2fa/method/mobile';
  await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'method_2fa': 'MOBILE', "trusted_device_id": id}),
  );
}

Future<Map<String, dynamic>> enable2FA3party() async {
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
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> checkTierAppCode(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/2fa/method/third_party';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'token': code}),
  );
  return jsonDecode(response.body);
}