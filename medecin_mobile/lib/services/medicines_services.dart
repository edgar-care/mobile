import 'dart:convert';
import 'package:edgar_pro/services/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllMedicines() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/medicine';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 201) {
    List<Map<String, dynamic>> medicines = [];
    if (jsonDecode(response.body)['medicament'] != null) {
      var tmp = jsonDecode(response.body)['medicament'];
      for (int i = 0; i < tmp.length; i++) {
        medicines.add(tmp[i]);
      }
      return medicines;
    }
  }
  return [];
}

Future<Map<String, dynamic>> getMedecineById(
    BuildContext context, String id) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'medicine/$id',
  );

  if (response != null) {
    return response["medicament"];
  } else {
    return {};
  }
}

