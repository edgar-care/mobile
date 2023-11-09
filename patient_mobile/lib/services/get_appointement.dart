import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prototype_1/widget/snackbar.dart';
import 'package:logger/logger.dart';


Future<Map<String, dynamic>?> getAppointement(BuildContext context) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
  await dotenv.load();
  final token = prefs.getString('token');
  final url = '${dotenv.env['URL']}patient/appointments';
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );


  final response = await http.get(
    Uri.parse(url),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 201) {
    final body = response.body;
    logger.i('Voici le body des rdv $body');
    return jsonDecode(body);
  } else {
    final scaffoldContext = context;
    logger.e(response.body);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      // ignore: use_build_context_synchronously
      SnackBar(content: ErrorSnackBar(
        message: 'Une erreur est survenue',
        context: scaffoldContext,
        duration: const Duration(seconds: 2),
      ),) 
    );
    return null;
  }
}