import "package:edgar_pro/services/request.dart";
import "package:flutter/material.dart";

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
    Map<String, dynamic> antecedent, String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.put,
    endpoint: 'dashboard/medical-antecedent/$id',
    needsToken: true,
    body: antecedent,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<bool> postMedicalAntecedent(
    Map<String, dynamic> antecedents, BuildContext context) async {
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