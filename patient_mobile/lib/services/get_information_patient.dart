// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Map<String, dynamic>> getMedicalFolder() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}dashboard/medical-info';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return jsonDecode(body)['medical_folder'];
  } else {
    Logger().e(response.statusCode);
    return {};
  }
}

Future<Map<String, Object>?> getInformationPersonnel(
    BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}dashboard/medical-info';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return populateInfoMedical(jsonDecode(body));
  } else {
    Logger().e(response.statusCode);
    return null;
  }
}

Map<String, Object> populateInfoMedical(Map<String, dynamic>? data) {
  Map<String, Object> tmp = {};
  if (data != null) {
    tmp = {
      'Prenom': data['Medical-info']?['name'] ?? 'Inconnu',
      'Nom': data['Medical-info']?['surname'] ?? 'Inconnu',
      'Sex': data['Medical-info']?['sex']?.toString() ?? 'Inconnu',
      'Anniversaire': data['Medical-info']?['birthdate'] ?? 'Inconnu',
      'Taille': data['Medical-info']?['height'] ?? 'Inconnu',
      'Poids': data['Medical-info']?['weight'] ?? 'Inconnu',
      'Medecin_traitant':
          data['patient_health']?['patients_primary_doctor'] ?? [],
      'Traitement_en_cours':
          data['patient_health']?['patients_treatment'] ?? [],
      'Allergies': data['patient_health']?['patients_allergies'] ?? [],
      'Maladies_connues': data['patient_health']?['patients_illness'] ?? [],
    };
  }
  return tmp;
}

Future<Map<String, Object>?> putInformationPatient(
    BuildContext context, Map<String, Object>? info) async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}dashboard/medical-info';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final body = {
    'onboarding_info': {
      'name': info?['Prenom'],
      'surname': info?['Nom'],
      'birthdate': info?['Anniversaire'],
      'sex': info?['Sex'],
      'height': info?['Taille'],
      'weight': info?['Poids'],
    },
    'onboarding_health': {
      'patients_primary_doctor': info?['Medecin_traitant'],
      'patients_illness': info?['Traitement_en_cours'],
      'patients_allergies': info?['Allergies'],
      'patients_treatment': info?['Maladies_connues'],
    },
  };

  final response = await http.put(
    Uri.parse(url),
    body: jsonEncode(body),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return populateInfoMedical(jsonDecode(body));
  } else {
    Logger().e(response.statusCode);
    return null;
  }
}
