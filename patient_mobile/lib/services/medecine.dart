import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<List<Map<String, dynamic>>> getMedecines() async {
  final url = '${dotenv.env['URL']}medicine';
  final response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return List<Map<String, dynamic>>.from(jsonDecode(body)["medicament"]);
  } else {
    return [];
  }
}
