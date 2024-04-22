import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
Future<bool> Register(String name, String lastName, int age, String sex,
    int height, int weight) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final url = '${dotenv.env['URL']}auth/p/register';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
      'name': name,
      'lastName': lastName,
      'age': age,
      'sex': sex,
      'height': height,
      'weight': weight,
    }),
  );
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

Future<List<Map<String, dynamic>>> getTraitement() async {
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
    return List<Map<String, dynamic>>.from(jsonDecode(body)["treatments"]);
  } else {
    return [];
  }
}

Future<List<Map<String, dynamic>>> getMedecines() async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}medicaments';
  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return List<Map<String, dynamic>>.from(jsonDecode(body)["medicament"]);
  } else {
    return [];
  }
}

Future<bool> postTraitement(List<Map<String, dynamic>> traitement) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatment';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
