import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Sexe { M, F }

// ignore: non_constant_identifier_names
Future<bool> Register(String mail, String password, String name,
    String lastName, Int age, Sexe sex, Int height, Int weight) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final url = '${dotenv.env['URL']}auth/p/register';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
      'name': prefs.getString('name'),
      'lastName': prefs.getString('lastName'),
      'age': prefs.getInt('age'),
      'sex': prefs.getInt('sex'),
      'height': prefs.getInt('height'),
      'weight': prefs.getInt('weight'),
    }),
  );
  if (response.statusCode == 201) {
    final body = response.body;
    final token = jsonDecode(body)['token'];
    prefs.setString('token', token);
    return true;
  } else {
    return false;
  }
}
