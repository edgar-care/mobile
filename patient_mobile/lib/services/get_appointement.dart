import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edgar/widget/snackbar.dart';

Future<Map<String, dynamic>?> getAppointement(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}patient/appointments';

  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    return jsonDecode(body);
  } else {
    final scaffoldContext = context;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
        // ignore: use_build_context_synchronously
        SnackBar(
      // ignore: use_build_context_synchronously
      content: ErrorSnackBar(
        message: 'Une erreur est survenue',
        context: scaffoldContext,
        duration: const Duration(seconds: 2),
      ),
    ));
    return null;
  }
}
