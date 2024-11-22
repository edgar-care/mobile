// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:edgar/widget.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<Map<String, dynamic>>> getDiagnostics(
    String status, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/appointments',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    List<Map<String, dynamic>> bAppointment = [];
    var temp = response['appointments'];
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

Future<List<dynamic>>  getAppointments(BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/appointments',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['appointments'];
  }
  return [];
}

Future<void> updateAppointment(
    String appointmentId, String newSlotId, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.put,
    endpoint: '/doctor/appointments/$appointmentId',
    needsToken: true,
    context: context,
    body: {'id': newSlotId},
  );

  if (response != null) {
    const TopSuccessSnackBar(
      message: 'Votre rendez-vous a bien été modifié',
    ).show(context);
  } else {
    const TopErrorSnackBar(
      message: 'Une erreur est survenue, veuillez réessayer',
    ).show(context);
  }
}

Future cancelAppointments(
    String id, BuildContext context, String reason) async {
  final response = await httpRequest(
    type: RequestType.delete,
    endpoint: '/doctor/appointments/$id',
    needsToken: true,
    context: context,
    body: {'reason': reason},
  );

  if (response != null) {
    const TopSuccessSnackBar(
      message: 'Votre rendez-vous a bien été annulé',
    ).show(context);
  } else {
    const TopErrorSnackBar(
      message: 'Une erreur est survenue, veuillez réessayer',
    ).show(context);
  }
}
