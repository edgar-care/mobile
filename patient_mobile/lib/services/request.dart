// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:edgar/widget.dart';
import 'package:edgar_app/services/logout_service.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

enum RequestType { get, post, put, delete }

// Fonction pour récupérer le token
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<dynamic> httpRequest({
  required RequestType type,
  required String endpoint,
  dynamic body,
  bool needsToken = true,
  Map<String, String>? additionalHeaders,
  required BuildContext context,
}) async {
  try {
    await dotenv.load();
    final baseUrl = dotenv.env['URL'];
    final url = Uri.parse('$baseUrl$endpoint');

    // Headers de base
    final headers = {
      'Content-Type': 'application/json',
    };

    // Ajout du token si nécessaire
    if (needsToken) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    if (Platform.isAndroid) {
      headers['User-Agent'] = 'Android/Edgar-App';
    } else {
      headers['User-Agent'] = 'iOS/Edgar-App';
    }
    // Ajout des headers supplémentaires
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    http.Response response;

    switch (type) {
      case RequestType.get:
        response = await http.get(url, headers: headers);
        break;
      case RequestType.post:
        response = await http.post(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case RequestType.put:
        response = await http.put(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      case RequestType.delete:
        response = await http.delete(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
    }

    // Gestion des réponses
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return json.decode(response.body);
      } catch (e) {
        return null; // Pour les réponses sans body
      }
    } else if (response.statusCode == 401) {
      TopErrorSnackBar(
        message: "Session expirée. Veuillez vous reconnecter.",
      ).show(context);
      logout(context);
      throw Exception("Session expirée. Veuillez vous reconnecter.");
    } else if (response.statusCode == 409) {
      Navigator.pushNamed(context, '/desactivate');
      throw Exception("Conflit détecté.");
    } else {
      throw Exception("Erreur ${response.statusCode}: ${response.body}");
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}
