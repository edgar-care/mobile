// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:prototype_1/widget/snackbar.dart';


  Future<String> initiateConversation() async {
    final url = '${dotenv.env['URL']}diagnostic/initiate';

    final response = await http.post(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      final body = response.body;
      final decodedBody = json.decode(body);
      final sessionId = decodedBody['sessionId'];
      return sessionId;
    } else {
      return '';
    }
  }

Future<Object?> getResponseMessage(BuildContext context, String msg, String idConversation) async {
  final url = '${dotenv.env['URL']}diagnostic/diagnose';
  var logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  final response = await http.post(
    Uri.parse(url),
    body: {
      'id': idConversation,
      'sentence': msg,
    },
  );
  if (response.statusCode == 200) {
    final body = response.body;
    logger.i('Voici le body des Messages $body');
    return body;
  } else {
    final scaffoldContext = context;
    logger.e(response.body);
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      SnackBar(
        content: ErrorSnackBar(
          message: 'Une erreur est survenue',
          context: scaffoldContext,
          duration: const Duration(seconds: 2),
        ),
      ),
    );
    return null;
  }
}