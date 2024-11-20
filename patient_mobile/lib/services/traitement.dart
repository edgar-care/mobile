import 'package:flutter/material.dart';
import 'package:edgar_app/services/request.dart';

Future<List<dynamic>> getTraitement(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'dashboard/treatments',
    needsToken: true,
  );

  if (response != null) {
    return response;
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

Future<List<dynamic>> getFollowUp(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'dashboard/treatment/follow-up',
    needsToken: true,
  );

  if (response != null) {
    return response;
  } else {
    return [];
  }
}

Future<List<dynamic>> postFollowUp(
    Map<String, dynamic> followUp, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'dashboard/treatment/follow-up',
    needsToken: true,
    body: followUp,
  );

  if (response != null) {
    return response;
  } else {
    return [];
  }
}

Future<bool> deleteFollowUpRequest(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.delete,
    endpoint: 'dashboard/treatment/follow-up/$id',
    needsToken: true,
  );

  if (response != null) {
    return true;
  } else {
    return false;
  }
}
