import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Créer un rendez-vous
Future<bool> postAppointementId(
    String id, String sessionId, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: 'appointments/$id',
      body: {'session_id': sessionId},
      context: context,
    );

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('appointment_doctor_id', response['rdv']['doctor_id']);
      prefs.setString(
          'appointment_start_date', response['rdv']['start_date'].toString());
      prefs.setString(
          'appointment_end_date', response['rdv']['end_date'].toString());
      return true;
    }
    return false;
  } catch (e) {
    Logger().e('Erreur lors de la création du rendez-vous: $e');
    return false;
  }
}

// Obtenir les rendez-vous d'un docteur
Future<Map<String, dynamic>> getAppoitementDoctorById(
    String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: 'doctor/$id/appointments',
    context: context,
  );

  if (response != null) {
    return response;
  } else {
    return {};
  }
}

// Obtenir les rendez-vous du patient
Future<List<Map<String, dynamic>>> getAppoitementPatient(
    BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.get,
      endpoint: 'patient/appointments',
      context: context,
    );

    if (response != null) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  } catch (e) {
    Logger().e('Erreur lors de la récupération des rendez-vous du patient: $e');
    return [];
  }
}

// Supprimer un rendez-vous
Future<bool> deleteAppointementId(String id, BuildContext context) async {
  try {
    await httpRequest(
      type: RequestType.delete,
      endpoint: 'appointments/$id',
      context: context,
    );
    return true;
  } catch (e) {
    Logger().e('Erreur lors de la suppression du rendez-vous: $e');
    return false;
  }
}

// Modifier un rendez-vous
Future<bool> putAppoitement(
    String idold, String idnew, BuildContext context) async {
  try {
    await httpRequest(
        type: RequestType.put,
        endpoint: 'appointments/$idold',
        body: {'id': idnew},
        context: context);
    return true;
  } catch (e) {
    Logger().e('Erreur lors de la modification du rendez-vous: $e');
    return false;
  }
}
