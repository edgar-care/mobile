// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar/widget.dart';

Future login(String email, String password, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String url = '${dotenv.env['URL']}auth/d/login';
  ScaffoldMessenger.of(context).showSnackBar(
      InfoSnackBar(message: "Connexion à l'application ...", context: context));
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    prefs.setString('token', jsonDecode(response.body)['token']);
    ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
      message: 'Connecté à l\'application',
      context: context,
    ));
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushNamed(context, '/dashboard');
  } else {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      message: 'Les identifiants ne correspondent pas !',
      context: context,
    ));
  }
}
