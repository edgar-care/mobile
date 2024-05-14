import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<bool> postAppointementId(String id, String sessionId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}appointments/$id';
  final body = jsonEncode({'session_id': sessionId});
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: body,
  );
  if (response.statusCode == 201) {
    Logger().i('response: ${response.body}');
    var body = jsonDecode(response.body);
    prefs.setString('appointment_doctor_id', body['rdv']['doctor_id']);
    prefs.setString(
        'appointment_start_date', body['rdv']['start_date'].toString());
    prefs.setString('appointment_end_date', body['rdv']['end_date'].toString());
    return true;
  } else {
    return false;
  }
}

Future<Map<String, dynamic>> getAppoitementDoctorById(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}doctor/$id/appointments';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 201) {
    final body = jsonDecode(response.body);
    return body;
  } else {
    return {};
  }
}

Future<List<Map<String, dynamic>>> getAppoitementPatient() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}patient/appointments';
  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return List<Map<String, dynamic>>.from(jsonDecode(body));
  } else {
    return [];
  }
}

Future<bool> deleteAppointementId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}appointments/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}
