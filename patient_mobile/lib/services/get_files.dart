import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getDocument(String id) async {
  final url = '${dotenv.env['URL']}document/upload/$id';

  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    final body = response.body;
    Logger().i(body);
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
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
    Logger().i(body);
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
  }
}

Future<Object?> postDocument(
    String category, String documentType, File file) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/upload';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: {
      'document': file.path,
      'isFavorite': 'false',
      'category': category,
      'documentType': documentType,
    },
  );
  if (response.statusCode == 201) {
    final body = response.body;
    Logger().i(body);
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
  }
}

Future<Object?> deleteDocument(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}document/delete/$id';

  final response = await http.delete(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    final body = response.body;
    Logger().i(body);
    return jsonDecode(body);
  } else {
    Logger().e(response.statusCode);
    Logger().e(url);
    return null;
  }
}
