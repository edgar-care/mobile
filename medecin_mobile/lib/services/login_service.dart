// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar/widget.dart';

Future<List<dynamic>> login(String email, String password, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}auth/d/login';
  ScaffoldMessenger.of(context).showSnackBar(
      InfoSnackBar(message: "Connexion à l'application ...", context: context));
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  if (response.statusCode == 200) {
    if ( jsonDecode(response.body)['token'] != null) {
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

Future missingPassword(String email) async {
  String url = '${dotenv.env['URL']}/auth/missing-password';
  await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
}

Future resetPassword(String password) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  String url = '${dotenv.env['URL']}/dashboard/devices';
  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({{"new_password": password}}),
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['devices'];
  }
  return [];
}

Future sendEmailCode(String email) async {
String url = '${dotenv.env['URL']}/auth/sending_email';
  await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email}),
  );
}

Future checkEmailCode(String email, String password, String code, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/email_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email' : email,
      'password': password,
      'token_2fa': code
    }),
  );
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future checkBackUpCode(String email, String password, String code, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/backup_code_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email' : email,
      'password': password,
      'backup_code': code
    }),
  );
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future checkThirdPartyCode(String email, String password, String code, BuildContext context)async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}/auth/third_party_2fa';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email' : email,
      'password': password,
      'token_2fa': code
    }),
  );
  if (response.statusCode == 200) {
    prefs.setString('token', jsonDecode(response.body)['token']);
    String encodedPayload = jsonDecode(response.body)['token'].split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}