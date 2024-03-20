// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:edgar_pro/widgets/login_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllPatientId() async{
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
    List<Map<String,dynamic>> patients = [];
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
  for(int i = 0; i < data.length; i++){
    patientInfo.add({
      'id': data[i]['id'] ?? 'Inconnu',
      'Prenom': data[i]['medical_info']['firstname'] ?? 'Inconnu',
      'Nom': data[i]['medical_info']['name'] ?? 'Inconnu',
      'date_de_naissance': DateFormat('yMd', "fr").format(DateTime.fromMillisecondsSinceEpoch(data[0]['medical_info']['birthdate'] * 1000)).toString(),
      'sexe': data[i]['medical_info']['sex'] ?? 'Inconnu',
      'taille': (data[i]['medical_info']['height']).toString(),
      'poids': (data[i]['medical_info']['weight']).toString(),
      'medecin_traitant': data[i]['medical_info']['primary_doctor_id'] ?? 'Inconnu',
      'medical_antecedents': data[i]['medical_info']['medical_antecedents'] ?? [],
    });
  }
}

Map<String, dynamic> patientInfoById = {};

void populatePatientInfobyId(Map<String, dynamic>? data) {

  if (data != null) {
    patientInfoById = {
      'id': data['patient']['id'] ?? 'Inconnu',
      'Prenom': data['medical_info']['firstname'] ?? 'Inconnu',
      'Nom': data['medical_info']['name'] ?? 'Inconnu',
      'date_de_naissance': DateFormat('yMd', "fr").format(DateTime.fromMillisecondsSinceEpoch(data['medical_info']['birthdate'] * 1000)).toString(),
      'sexe': data['medical_info']['sex'] ?? 'Inconnu',
      'taille': (data['medical_info']['height']).toString(),
      'poids': (data['medical_info']['weight']).toString(),
      'medecin_traitant': data['medical_info']['primary_doctor_id'] ?? 'Inconnu',
      'medical_antecedents': data['medical_info']['medical_antecedents'] ?? [],
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
  if (response.statusCode == 200) {
    populatePatientInfobyId(jsonDecode(response.body));
    return patientInfoById;
  }
  if (response.statusCode != 200) {
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
      'Medecin_traitant': data['patient_health']?['patients_primary_doctor'] ?? 'Inconnu',
    };
  }
}

Future putInformationPatient(BuildContext context, Map<String, dynamic>? info, String id) async {
  await dotenv.load();
  final url = '${dotenv.env['URL']}doctor/patient/$id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  int poids = int.tryParse(info?['poids'] ?? 0) ?? 0;
  int taille = int.tryParse(info?['taille'] ?? 0) ?? 0;

  String day = info?['date_de_naissance']?.substring(0, 2) ?? '00';
  String month = info?['date_de_naissance']?.substring(3, 5) ?? '00';
  String year = info?['date_de_naissance']?.substring(6, 10) ?? '0000';
  int date = DateTime.parse('$year-$month-$day').millisecondsSinceEpoch ~/ 1000;

  final body = {
    'firstname': info?['Prenom'],
    'name': info?['Nom'],
    'birthdate': date,
    'sex': info?['sexe'],
    'height': taille,
    'weight': poids,
    'primary_doctor_id': info?['medecin_traitant'],
    'medical_antecedents': info?['medical_antecedents'],
    'onboarding_status': 'DONE'
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


  int poids = int.tryParse(info?['poids'] ?? '0') ?? 0;
  int taille = int.tryParse(info?['taille'] ?? '0') ?? 0;

  String day = info?['date']?.substring(0, 2) ?? '00';
  String month = info?['date']?.substring(3, 5) ?? '00';
  String year = info?['date']?.substring(6, 10) ?? '0000';
  int date = DateTime.parse('$year-$month-$day').millisecondsSinceEpoch ~/ 1000;

  final body = {
    'email' : info?['email'],
    'medical_info': {
      'name': info?['nom'],
      'firstname': info?['prenom'],
      'birthdate': date,
      'sex': info?['sexe'],
      'weight': poids,
      'height': taille,
      'primary_doctor_id': info?['medecin_traitant'],
      'medical_antecedents': info?['medical_antecedents'],
      'onboarding_status': 'DONE'
    },
  };

  final response = await http.post(
    Uri.parse(url),
    body: jsonEncode(body),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient ajouté avec succès', context: context));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de l\'ajout du patient', context: context));
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
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(
        message: 'Patient supprimé avec succès', context: context));
  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(ErrorLoginSnackBar(
        message: 'Erreur lors de la suppression du patient', context: context));
  }
}