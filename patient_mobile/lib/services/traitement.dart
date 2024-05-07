import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> getTraitement() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
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

Future<bool> postTraitement(Map<String, dynamic> traitement) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatment';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
