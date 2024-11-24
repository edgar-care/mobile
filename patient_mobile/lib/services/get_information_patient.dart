// ignore_for_file: use_build_context_synchronously
import 'package:edgar_app/services/request.dart';
import "package:flutter/material.dart";

Future<Map<String, dynamic>> getMedicalFolder(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'dashboard/medical-info',
    context: context,
    needsToken: true,
  );

  if (response != null) {
    return response['medical_folder'];
  } else {
    return {};
  }
}

Future<Map<String, Object>?> getInformationPersonnel(
    BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'dashboard/medical-info',
    context: context,
    needsToken: true,
  );

  if (response != null) {
    return populateInfoMedical(response, context);
  } else {
    return null;
  }
}

Map<String, Object> populateInfoMedical(
    Map<String, dynamic>? data, BuildContext context) {
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
    BuildContext context, Map<String, Object>? info, tmpInfo) async {
  final response = await httpRequest(
    type: RequestType.put,
    endpoint: 'dashboard/medical-info',
    context: context,
    needsToken: true,
    body: info,
  );
  if (response != null) {
    return populateInfoMedical(response, context);
  } else {
    return tmpInfo;
  }
}
