import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future disableAccount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}/auth/disable_account';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}

Future resetPassword(String password) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/devices';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({{"new_password": password}}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['devices'];
  }
  return [];
}