// ignore_for_file: file_names

import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


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

  final response = await http.post(
    Uri.parse(url),
    body: {
      'id': idConversation,
      'sentence': msg,
    },
  );
  if (response.statusCode == 200) {
    final body = response.body;
    return body;
  } else {
    final scaffoldContext = context;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
      const SnackBar(
        content: Text('Une erreur est survenue'),
      ),
    );
    return null;
  }
}