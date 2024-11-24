import 'dart:io';
import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllDocument(BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.get,
    endpoint: 'document/download',
    needsToken: true,
  );

  if (response != null) {
    return List<Map<String, dynamic>>.from(response["document"]);
  } else {
    return [];
  }
}

Future<Object?> changeFavorite(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.post,
    endpoint: 'document/favorite/$id',
    needsToken: true,
  );

  if (response != null) {
    return response;
  } else {
    return null;
  }
}

Future<Object?> deleteFavory(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.delete,
    endpoint: 'document/favorite/$id',
    needsToken: true,
  );

  if (response != null) {
    return response;
  } else {
    return null;
  }
}

Future<bool> postDocument(String category, String documentType, File file,
    BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  await dotenv.load();
  final url = '${dotenv.env['URL']}document/upload';

  final docT = {
    'Ordonnance': 'PRESCRIPTION',
    'Certificat': 'CERTIFICATE',
    'Radio': 'XRAY',
    'Autre': 'OTHER',
  }[documentType];

  final categoryT = {
    'Général': 'GENERAL',
    'Finance': 'FINANCE',
  }[category];

  final request = http.MultipartRequest('POST', Uri.parse(url))
    ..headers['Authorization'] = 'Bearer $token';
  request.fields['category'] = categoryT!;
  request.fields['documentType'] = docT!;
  request.files.add(await http.MultipartFile.fromPath('document', file.path));
  request.fields['isFavorite'] = 'false';

  final response = await request.send();
  if (response.statusCode == 200) {
    await response.stream.bytesToString();
    return true;
  } else {
    await response.stream.bytesToString();
    return false;
  }
}

Future<Object?> deleteDocument(String id, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.delete,
    endpoint: 'document/$id',
    needsToken: true,
  );

  if (response != null) {
    return response;
  } else {
    return null;
  }
}

Future<Object?> modifyDocument(
    String id, String name, BuildContext context) async {
  final response = await httpRequest(
    context: context,
    type: RequestType.put,
    endpoint: 'document/$id',
    needsToken: true,
    body: {'name': name},
  );
  if (response != null) {
    return response;
  } else {
    return null;
  }
}
