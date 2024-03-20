// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return jsonDecode(response.body)['appointments'];
  }
  if (response.statusCode != 200) {
    return [];
  }
  return [];
}

Future <void> updateAppointment(String appointmentId, String newSlotId, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointments/$appointmentId';
  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({'id': newSlotId}),
  );
  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(message: 'Votre rendez-vous a bien été modifié', context: context,));
  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(message: 'Une erreur est survenue, veuillez réessayer', context: context,));
  }
}

Future cancelAppointments(String id, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}doctor/appointment/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(message: 'Votre rendez-vous a bien été annulé', context: context,));
  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(message: 'Une erreur est survenue, veuillez réessayer', context: context,));
  }
}