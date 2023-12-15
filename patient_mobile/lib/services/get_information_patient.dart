// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/widget/snackbar.dart';

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
    populateInfoMedical(jsonDecode(body));
    return infoMedical;
  } else {
    final scaffoldContext = context;
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: ErrorSnackBar(
          message: 'La recuperation des informations personnelles a échoué',
          context: scaffoldContext,
          duration: const Duration(seconds: 2),
        ),
      ),
    );
    return null;
  }
}

Map<String, Object> infoMedical = {};

void populateInfoMedical(Map<String, dynamic>? data) {
  if (data != null) {
    infoMedical = {
      'Nom': data['patient_info']?['surname'] ?? 'Inconnu',
      'Sex': data['patient_info']?['sex']?.toString() ?? 'Inconnu',
      'Anniversaire': data['patient_info']?['birthdate'] ?? 'Inconnu',
      'Taille': data['patient_info']?['height'] ?? 'Inconnu',
      'Poids': data['patient_info']?['weight'] ?? 'Inconnu',
      'Medecin_traitant':
          data['patient_health']?['patients_primary_doctor'] ?? 'Inconnu',
      'Traitement_en_cours': 'Aucun',
      'Allergies': data['patient_health']?['patients_allergies'] ?? 'Inconnu',
      'Maladies_connues':
          data['patient_health']?['patients_illness'] ?? 'Inconnu',
    };
  }
}
