import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

Future<List<dynamic>> getAllDoctor() async {
  final url = '${dotenv.env['URL']}doctors';
  final response = await http.get(
    Uri.parse(url),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
  if (response.statusCode == 200) {
    final body = response.body;
    return jsonDecode(body)["Doctors"];
  } else {
    return [];
  }
}
