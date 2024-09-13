// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:edgar/widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
Future<bool> RegisterUser(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final url = '${dotenv.env['URL']}auth/p/register';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    final body = response.body;
    final token = jsonDecode(body)['token'];
    prefs.setString('token', token);
    return true;
  } else {
    return false;
  }
}

Future<List<dynamic>> login(
    String email, String password, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}auth/p/login';
  ScaffoldMessenger.of(context).showSnackBar(
      InfoSnackBar(message: "Connexion à l'application ...", context: context));
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
  if (response.statusCode == 200) {
    if (jsonDecode(response.body)['token'] != null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      prefs.setString('token', jsonDecode(response.body)['token']);
      String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
      String decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);
      ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
        message: 'Connecté à l\'application',
        context: context,
      ));
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/dashboard');
      return [];
    } else {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      return jsonDecode(response.body)['2fa_methods'];
    }
  } else {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      message: 'Les identifiants ne correspondent pas !',
      context: context,
    ));
    return [];
  }
}

Future<bool> postMedicalInfo(Map<String, dynamic> traitement) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  final url = '${dotenv.env['URL']}dashboard/medical-info';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
    body: jsonEncode(traitement),
  );
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future sendEmailCode(String email) async {
  String url = '${dotenv.env['URL']}/auth/sending_email';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}

Future checkEmailCode(
    String email, String password, String code, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/email_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password, 'token_2fa': code}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
    String decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future checkBackUpCode(
    String email, String password, String code, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/backup_code_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body:
        jsonEncode({'email': email, 'password': password, 'backup_code': code}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
    String decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future checkThirdPartyCode(
    String email, String password, String code, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/third_party_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password, 'token_2fa': code}),
  );
  Logger().d(code);
  Logger().d(response.body);
  Logger().d(response.statusCode);
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
    String decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future missingPassword(String email) async {
  String url = '${dotenv.env['URL']}/auth/missing-password';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
  Logger().d(response.body);
  Logger().d(response.statusCode);
}