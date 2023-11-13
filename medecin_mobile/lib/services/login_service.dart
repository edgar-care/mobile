import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medecin_mobile/widgets/login_snackbar.dart';

Future login(String email, String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = '${dotenv.env['URL']}auth/d/login';
    final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      prefs.setString('token', jsonDecode(response.body)['token']);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(message: 'Connecté à l\'application', context: context,));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SuccessLoginSnackBar(message: 'Les identifiants ne correspondent pas !', context: context,));
    }
}

