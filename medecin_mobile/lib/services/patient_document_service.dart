import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar_pro/services/request.dart';

Future<List<Map<String, dynamic>>> getDocumentsIds(
    String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/patient/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    List<Map<String, dynamic>> documents = [];
    if (response['document_ids'] != null) {
      var tmp = response['document_ids'];
      for (int i = 0; i < tmp.length; i++) {
        // ignore: use_build_context_synchronously
        documents.add(await getDocumentsbyId(tmp[i], context));
      }
      return documents;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

Future<Map<String, dynamic>> getDocumentsbyId(
    String id, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.get,
    endpoint: '/doctor/document/$id',
    needsToken: true,
    context: context,
  );

  if (response != null) {
    return response['download'];
  } else {
    return {};
  }
}

Future<Object?> postDocument(
    String category, String documentType, String id, File file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}doctor/document/upload';

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
  request.fields['patient_id'] = id;

  final response = await request.send();

  if (response.statusCode == 201) {
    final body = await response.stream.bytesToString();
    return body;
  } else {
    await response.stream.bytesToString();
    return null;
  }
}
