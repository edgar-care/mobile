// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar/widget.dart';

Future<List<Map<String, dynamic>>> getDiagnostics(String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointments';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> bAppointment = [];
    var temp = jsonDecode(response.body)['appointments'];
    for (var i = 0; i < temp.length; i++) {
      if (temp[i]['id_patient'].toString().isNotEmpty &&
          temp[i]['appointment_status'] == status) {
        bAppointment.add(temp[i]);
      }
    }
    return bAppointment;
  } else {
    return [];
  }
}

Future<List<dynamic>> getAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointments';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    var tempAp = jsonDecode(response.body)['appointments'];

    return tempAp;
  }
  if (response.statusCode != 200) {
    return [];
  }
  return [];
}

Future<void> updateAppointment(
    String appointmentId, String newSlotId, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointments/$appointmentId';
  await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'id': newSlotId}),
  );
}

Future cancelAppointments(
    String id, BuildContext context, String reason) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointments/$id';
  final response = await http.delete(Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
      body: jsonEncode({'reason': reason}));
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
      message: 'Votre rendez-vous a bien été annulé',
      context: context,
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      message: 'Une erreur est survenue, veuillez réessayer',
      context: context,
    ));
  }
}
