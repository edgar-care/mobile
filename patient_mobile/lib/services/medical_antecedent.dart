import 'package:flutter/material.dart';
import 'package:edgar_app/services/request.dart';
import 'package:logger/logger.dart';

Future<List<Map<String, dynamic>>> getMedicalAntecedent(
    BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: '/dashboard/medical-antecedent',
    needsToken: true,
  );

  Logger().d(response);

  if (response != null) {
    return [
      for (var antecedent in response) antecedent as Map<String, dynamic>
    ];
  } else {
    return [];
  }
}

Future<bool> postTraitement(
    Map<String, dynamic> traitement, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'dashboard/treatment',
    needsToken: true,
    body: traitement,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteTraitementRequest(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.delete,
    endpoint: 'dashboard/treatment/$id',
    needsToken: true,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> putTraitement(
    Map<String, dynamic> traitement, String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.put,
    endpoint: 'dashboard/treatment/$id',
    needsToken: true,
    body: traitement,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> deleteMedicalAntecedent(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.put,
    endpoint: 'dashboard/treatment/$id',
    needsToken: true,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> putMedicalAntecedent(
    Map<String, dynamic> antecedent, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.put,
    endpoint: 'dashboard/medical-antecedent',
    needsToken: true,
    body: antecedent,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> postMedicalAntecedent(Map<String, dynamic> antecedents, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'dashboard/medical-antecedent',
    needsToken: true,
    body: antecedents,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}