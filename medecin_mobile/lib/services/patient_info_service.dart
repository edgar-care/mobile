// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllPatientId() async {
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
  if (response.statusCode == 200) {
    populatePatientInfoAll(jsonDecode(response.body)['patients']);
    List<Map<String, dynamic>> patients = [];
    for (var i = 0; i < patientInfo.length; i++) {
      if (patientInfo[i].isNotEmpty) {
        patients.add(patientInfo[i]);
      }
    }
    return patients;
  }
  if (response.statusCode != 200) {
    return [];
  }
  return [];
}

List<Map<String, dynamic>> patientInfo = [];

void populatePatientInfoAll(List<dynamic> data) {
  patientInfo = [];
  for (int i = 0; i < data.length; i++) {
    patientInfo.add({
      'id': data[i]['id'] ?? 'Inconnu',
      'Prenom': data[i]['medical_folder']['firstname'] ?? 'Inconnu',
      'Nom': data[i]['medical_folder']['name'] ?? 'Inconnu',
      'date_de_naissance': DateFormat('yMd', "fr")
          .format(DateTime.fromMillisecondsSinceEpoch(
              data[i]['medical_folder']['birthdate'] * 1000))
          .toString(),
      'sexe': data[i]['medical_folder']['sex'] ?? 'Inconnu',
      'taille': (data[i]['medical_folder']['height']).toString(),
      'poids': (data[i]['medical_folder']['weight']).toString(),
      'medecin_traitant':
          data[i]['medical_folder']['primary_doctor_id'] ?? 'Inconnu',
      'medical_antecedents':
          data[i]['medical_folder']['medical_antecedents'] ?? [],
    });
  }
}

Map<String, dynamic> patientInfoById = {};

void populatePatientInfobyId(Map<String, dynamic>? data) {
  if (data != null) {
    patientInfoById = {
      'id': data['id'] ?? 'Inconnu',
      'Prenom': data['medical_folder']['firstname'] ?? 'Inconnu',
      'Nom': data['medical_folder']['name'] ?? 'Inconnu',
      'date_de_naissance': DateFormat('yMd', "fr")
          .format(DateTime.fromMillisecondsSinceEpoch(
              data['medical_folder']['birthdate'] * 1000))
          .toString(),
      'sexe': data['medical_folder']['sex'] ?? 'Inconnu',
      'taille': (data['medical_folder']['height']).toString(),
      'poids': (data['medical_folder']['weight']).toString(),
      'medecin_traitant':
          data['medical_folder']['primary_doctor_id'] ?? 'Inconnu',
      'medical_antecedents':
          data['medical_folder']['medical_antecedents'] == null
              ? []
              : data['medical_folder']['medical_antecedents']
                  .map((antecedent) => {
                        'name': antecedent['name'],
                        'treatments': antecedent['medicines'] == null
                            ? []
                            : antecedent['medicines']
                                .map((medicine) => {
                                      'id': medicine['id'],
                                      'quantity': medicine['quantity'],
                                      'period': medicine['period'],
                                      'day': medicine['day'],
                                      'medicine_id': medicine['medicine_id']
                                    })
                                .toList(),
                        'still_relevant': antecedent['still_relevant']
                      })
                  .toList(),
    };
  }
}

Future<Map<String, dynamic>> getPatientById(String id) async {
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
  if (response.statusCode == 200) {
    populatePatientInfobyId(jsonDecode(response.body));
    return patientInfoById;
  }
  if (response.statusCode != 200) {
    return <String, dynamic>{};
  }
  return <String, dynamic>{};
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
    };
  }
}

Future putInformationPatient(
    BuildContext context, Map<String, Object> body, String id) async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}doctor/patient/$id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  Logger().d(body);
  final response = await http.put(
    Uri.parse(url),
    body: jsonEncode(body),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    populateInfoMedical(jsonDecode(body));
    return true;
    //modifié avec success
  } else {
    return false;
  }
}

Future addPatientService(
    BuildContext context, Map<String, dynamic> traitement) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}doctor/patient';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient ajouté avec succès', context: context));
    return true;
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de l\'ajout du patient', context: context));
    return false;
  }
}

Future deletePatientService(String id, BuildContext context) async {
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
  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient supprimé avec succès', context: context));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de la suppression du patient', context: context));
  }
}
