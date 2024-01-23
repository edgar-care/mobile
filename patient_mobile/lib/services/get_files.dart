import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getAllDocument() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/download';

  final response = await http
      .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    final body = response.body;
    return List<Map<String, dynamic>>.from(jsonDecode(body)["document"]);
  } else {
    Logger().e(response.statusCode);
    return [];
  }
}

Future<Object?> changeFavorite(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/favorite/$id';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(token);
    return null;
  }
}

Future<Object?> postDocument(
    String category, String documentType, File file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
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
  if (response.statusCode == 201) {
    final body = await response.stream.bytesToString();
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);

    return null;
  }
}

Future<Object?> deleteDocument(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/$id';

  final response = await http.delete(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
  }
}

Future<Object?> modifyDocument(String id, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/$id';

  final response = await http.put(
    Uri.parse(url),
    body: jsonEncode({'name': name}),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
  }
}
