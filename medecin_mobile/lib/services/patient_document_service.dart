import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getDocumentsIds(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/doctor/patient/$id';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> documents = [];
    var tmp = jsonDecode(response.body)['document_ids'];
    for(int i = 0; i < tmp.length; i++) {
        documents.add(await getDocumentsbyId(tmp[i]));
    }
    return documents;
  }
  else {
    return [];
  }
}

Future <Map<String, dynamic>> getDocumentsbyId (String id) async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  String url = '${dotenv.env['URL']}/doctor/document/$id';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 201) {
    return jsonDecode(response.body)['download'];
  }
  else {
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

  Logger().d(request.fields);
  Logger().d(request.files);

  final response = await request.send();

  if (response.statusCode == 201) {
    final body = await response.stream.bytesToString();
    return jsonDecode(body);
  } else {
    Logger().d(response.statusCode);
    Logger().d(file.path);
    final body = await response.stream.bytesToString();
    Logger().d(jsonDecode(body));
    return null;
  }
}