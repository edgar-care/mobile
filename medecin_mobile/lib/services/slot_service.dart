import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getSlot() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/slots';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['slot'];
  }
  if (response.statusCode != 200) {
    return [];
  }
  return [];
}

Future<Object?> postSlot(DateTime date) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}doctor/slot';
  final start = date.toUtc().millisecondsSinceEpoch ~/ 1000	;
  final end =
      ((date.add(const Duration(minutes: 30))).toUtc().millisecondsSinceEpoch  ~/ 1000);
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'start_date': start, 'end_date': end}),
  );
  if (response.statusCode == 201) {
    return jsonDecode(response.body);
  }
  if (response.statusCode != 201) {
    return null;
  }
  return null;
}

Future deleteSlot(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/slot/$id';
  await http.delete(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token'
    },
  );
}
