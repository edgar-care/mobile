import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<dynamic>> getTraitement() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatments';
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    return body;
  } else {
    return [];
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
    Logger().e('Erreur lors de la création du traitement');
    return false;
  }
}

Future<bool> deleteTraitementRequest(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatment/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    Logger().e(response.body);
    return false;
  }
}

Future<bool> putTraitement(Map<String, dynamic> traitement, String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/treatment/$id';
  final response = await http.put(
    Uri.parse(url),
    body: jsonEncode(traitement),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    Logger().e(response.body);
    return false;
  }
}
