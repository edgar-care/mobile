import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
Future<bool> RegisterUser(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final url = '${dotenv.env['URL']}auth/p/register';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  Logger().i(response.body);
  if (response.statusCode == 200) {
    final body = response.body;
    final token = jsonDecode(body)['token'];
    prefs.setString('token', token);
    return true;
  } else {
    Logger().i(response.body);
    return false;
  }
}

Future<Map<String, dynamic>> getTraitement() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatments';
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return Map<String, dynamic>.from(jsonDecode(body));
  } else {
    return {};
  }
}

Future<List<Map<String, dynamic>>> getMedecines() async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}medicine';
  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 201) {
    final body = response.body;
    Logger().i(jsonDecode(body));
    return List<Map<String, dynamic>>.from(jsonDecode(body)["medicament"]);
  } else {
    return [];
  }
}

Future<bool> postTraitement(Map<String, dynamic> traitement) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatment';
  Logger().i(traitement);
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  Logger().i(response.body);
  Logger().i(response.statusCode);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> postMedicalInfo(Map<String, dynamic> traitement) async {
  await dotenv.load();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/medical-info';
  Logger().i(traitement);
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  Logger().i(response.body);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<List<dynamic>> getAllDoctor() async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}doctors';
  final response = await http.get(
    Uri.parse(url),
  );
  Logger().i(response.body);
  if (response.statusCode == 200) {
    final body = response.body;
    return jsonDecode(body)["Doctors"];
  } else {
    return [];
  }
}
