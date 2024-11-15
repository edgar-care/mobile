import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllPrescription(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/dashboard/prescription';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> prescriptions = [];
    if (jsonDecode(response.body)['prescriptions'] != null) {
      var tmp = jsonDecode(response.body)['prescriptions'];
      for (int i = 0; i < tmp.length; i++) {
        if (tmp[i]['patient_id'] == id) {
          prescriptions.add(await getPrescriptionbyId(tmp[i]['id']));
        }
      }
      return prescriptions;
    }
  }
  return [];
}

Future<Map<String, dynamic>> getPrescriptionbyId(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/dashboard/prescription/$id';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {};
  }
}

Future<bool> postPrescription(Map<String, dynamic> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/dashboard/prescription';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}