// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> diagnosticInfo = {};

void mapperDiagnostic(Map<String, dynamic> data) {
  diagnosticInfo = {
    "fiability": data['fiability'] ?? 0,
    "diseases": data['diseases'] ?? [],
    "symptoms": data['symptoms'] ?? [],
    "logs": data['logs'] ?? [],
    "session_id" : data['session_id'] ?? '',
  };
}

Future<Map<String, dynamic>> getSummary(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}diagnostic/summary/$id';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    mapperDiagnostic(jsonDecode(response.body));
    return diagnosticInfo;
  } else {
    return {};
  }
}

Future<void> postDiagValidation(BuildContext context, String id,
    bool validation, String reason, String health) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/diagnostic/$id';
  final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        if (reason != '') 'reason': reason,
        'validation': validation,
        if (health != '') "health_method": health
      }));
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
        message: "Réponse envoyée avec succes", context: context));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
        message: "Une erreur est survenue", context: context));
  }
}
