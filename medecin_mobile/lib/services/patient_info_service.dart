// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<Map<String, dynamic>>> getAllPatientId(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/patients',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    populatePatientInfoAll(response['patients']);
    List<Map<String, dynamic>> patients = [];
    for (var i = 0; i < patientInfo.length; i++) {
      if (patientInfo[i].isNotEmpty) {
        patients.add(patientInfo[i]);
      }
    }
    return patients;
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
                        'antedisease_id': antecedent['id'],
                        'name': antecedent['name'],
                        'treatments': antecedent['medicines'] == null
                            ? []
                            : antecedent['medicines']
                                .map((medicine) => {
                                      'treatment_id': medicine['id'],
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

Future<Map<String, dynamic>> getPatientById(
    String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/patient/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    populatePatientInfobyId(response);
    return patientInfoById;
  }

  return {};
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
  final response = await httpRequest(
    type: RequestType.put,
    endpoint: '/doctor/patient/$id',
    needsToken: true,
    context: context,
    body: body,
  );

  if (response != null) {
    populateInfoMedical(response);
    return true;
  }
  return false;
}

Future addPatientService(
    BuildContext context, Map<String, dynamic> traitement) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/doctor/patient',
    needsToken: true,
    context: context,
    body: traitement,
  );

  if (response != null) {
    const TopSuccessSnackBar(message: 'Patient ajouté avec succès')
        .show(context);
    return true;
  } else {
    const TopErrorSnackBar(message: 'Erreur lors de l\'ajout du patient')
        .show(context);
    return false;
  }
}

Future deletePatientService(String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.delete,
    endpoint: '/doctor/patient/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    const TopSuccessSnackBar(message: 'Patient supprimé avec succès')
        .show(context);
    return true;
  } else {
    const TopErrorSnackBar(message: 'Erreur lors de la suppression du patient')
        .show(context);
    return false;
  }
}
