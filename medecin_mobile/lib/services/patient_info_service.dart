// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getAllPatientId() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/doctor/patients';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 201) {
    prefs.setString('id', jsonDecode(response.body)['patients'][0]['id']);
    return jsonDecode(response.body)['patients'][0]['patient_ids'];
  }
  if (response.statusCode != 201) {
    return [];
  }
  return [];
}

Map<String, dynamic> patientInfo = {};

void populatePatientInfo(Map<String, dynamic>? data) {
  if (data != null) {
    patientInfo = {
      'id': data['patient']['id'] ?? 'Inconnu',
      'Prenom': data['onboarding_info']['name'] ?? 'Inconnu',
      'Nom': data['onboarding_info']['surname'] ?? 'Inconnu',
      'date_de_naissance': data['onboarding_info']['birthdate'] ?? 'Inconnu',
      'sexe': data['onboarding_info']['sex'] ?? 'Inconnu',
      'taille': data['onboarding_info']['height'] ?? 'Inconnu',
      'poids': data['onboarding_info']['weight'] ?? 'Inconnu',
      'medecin_traitant': data['onboarding_health']['patients_primary_doctor'] ?? 'Inconnu',
      'allergies': data['onboarding_health']['patients_allergies'] ?? [],
      'maladies_connues': data['onboarding_health']['patients_illness'] ?? [],
      'traitement_en_cours': data['onboarding_health']['patients_treatment'] ?? [],
    };
  }
}

Future <Map<String,dynamic>> getPatientById(String id) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/doctor/patient/$id';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 201) {
    populatePatientInfo(jsonDecode(response.body));
    return patientInfo;
  }
  if (response.statusCode != 201) {
    return <String, dynamic>{};
  }
  return <String,dynamic>{};
}


Map<String, Object> infoMedical = {};

void populateInfoMedical(Map<String, dynamic>? data) {
  if (data != null) {
    infoMedical = {
      'prenom': data['patient_info']?['name'] ?? 'Inconnu',
      'nom': data['patient_info']?['surname'] ?? 'Inconnu',
      'sexe': data['patient_info']?['sex']?.toString() ?? 'Inconnu',
      'date_de_naissance': data['patient_info']?['birthdate'] ?? 'Inconnu',
      'Taille': data['patient_info']?['height'] ?? 'Inconnu',
      'Poids': data['patient_info']?['weight'] ?? 'Inconnu',
      'Medecin_traitant':
          data['patient_health']?['patients_primary_doctor'] ?? 'Inconnu',
      'Traitement_en_cours':
          data['patient_health']?['patients_treatment'] ?? [],
      'Allergies': data['patient_health']?['patients_allergies'] ?? [],
      'Maladies_connues': data['patient_health']?['patients_illness'] ?? [],
    };
  }
}

Future putInformationPatient(BuildContext context, Map<String, Object>? info, String id) async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}doctor/patient/$id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final body = {
    'onboarding_info': {
      'name': info?['Prenom'],
      'surname': info?['Nom'],
      'birthdate': info?['date_de_naissance'],
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
    populateInfoMedical(jsonDecode(body));
    //modifié avec success
  }
}

Future addPatientService(BuildContext context, Map<String, dynamic>? info) async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}doctor/patient';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final body = {
    'patient_input': {
      'email' : info?['email'],
    },
    'onboarding_info': {
      'name': info?['prenom'],
      'surname': info?['nom'],
      'birthdate': info?['date'],
      'sex': info?['sexe'],
      'weight': info?['poids'],
      'height': info?['taille'],
    },
    'onboarding_health': {
      'patients_primary_doctor': info?['medecin'],
      'patients_illness': info?['traitements'],
      'patients_allergies': info?['allergies'],
      'patients_treatment': info?['maladies'],
    },
  };

  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode(body),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient ajouté avec succès', context: context));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de l\'ajout du patient', context: context));
  }

}

Future deletePatient(String id, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/doctor/patient/$id';
  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient supprimé avec succès', context: context));
  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de la suppression du patient', context: context));
  }
}