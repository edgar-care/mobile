import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<dynamic>> getAllDevices() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/devices';
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

Future addTrustDevices(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/2fa/device/$id';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
  return;
}

Future removeDevice(String id) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/2fa/device/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}