// ignore_for_file: use_build_context_synchronously

import 'package:edgar_app/services/request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:edgar/widget.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Inscription utilisateur
Future<bool> registerUser(
    String email, String password, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: 'auth/p/register',
      needsToken: false,
      body: {
        'email': email,
        'password': password,
      },
      context: context,
    );

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);
      return true;
    }
    return false;
  } catch (e) {
    Logger().e('Erreur lors de l\'inscription: $e');
    return false;
  }
}

// Connexion
Future<List<dynamic>> login(
    String email, String password, BuildContext context) async {
  try {
    TopLoadingSnackBar().show(context);

    final response = await httpRequest(
      type: RequestType.post,
      endpoint: 'auth/p/login',
      needsToken: false,
      body: {'email': email, 'password': password},
      context: context,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (response != null) {
      if (response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', response['token']);

        // Décodage du token
        String encodedPayload = response['token'].split('.')[1];
        String decodedPayload =
            utf8.decode(base64.decode(base64.normalize(encodedPayload)));
        prefs.setString('id', jsonDecode(decodedPayload)["id"]);

        TopSuccessSnackBar(
          message: "Connexion réussie",
        ).show(context);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, '/dashboard');
        return [];
      } else {
        return response['2fa_methods'];
      }
    }

    TopErrorSnackBar(
      message: "Erreur lors de la connexion",
    ).show(context);
    return [];
  } catch (e) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    TopErrorSnackBar(
      message: "Erreur lors de la connexion",
    ).show(context);
    return [];
  }
}

// Enregistrement des informations médicales
Future<bool> postMedicalInfo(
    Map<String, dynamic> traitement, BuildContext context) async {
  try {
    await httpRequest(
      type: RequestType.post,
      endpoint: 'dashboard/medical-info',
      body: traitement,
      context: context,
    );
    return true;
  } catch (e) {
    Logger()
        .e('Erreur lors de l\'enregistrement des informations médicales: $e');
    return false;
  }
}

// Envoi du code email
Future<void> sendEmailCode(String email, BuildContext context) async {
  try {
    await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/sending_email',
      needsToken: false,
      body: {'email': email},
      context: context,
    );
  } catch (e) {
    Logger().e('Erreur lors de l\'envoi du code email: $e');
  }
}

// Vérification du code email
Future<void> checkEmailCode(
    String email, String password, String code, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/email_2fa',
      needsToken: false,
      body: {'email': email, 'password': password, 'token_2fa': code},
      context: context,
    );

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);

      String encodedPayload = response['token'].split('.')[1];
      String decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);

      Navigator.pushNamed(context, '/dashboard');
    }
  } catch (e) {
    Logger().e('Erreur lors de la vérification du code email: $e');
  }
}

// Vérification du code de backup
Future<void> checkBackUpCode(
    String email, String password, String code, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/backup_code_2fa',
      needsToken: false,
      body: {'email': email, 'password': password, 'backup_code': code},
      context: context,
    );

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);

      String encodedPayload = response['token'].split('.')[1];
      String decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);

      Navigator.pushNamed(context, '/dashboard');
    }
  } catch (e) {
    Logger().e('Erreur lors de la vérification du code de backup: $e');
  }
}

// Vérification du code tiers
Future<void> checkThirdPartyCode(
    String email, String password, String code, BuildContext context) async {
  try {
    final response = await httpRequest(
        type: RequestType.post,
        endpoint: '/auth/third_party_2fa',
        needsToken: false,
        body: {'email': email, 'password': password, 'token_2fa': code},
        context: context);

    if (response != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);

      String encodedPayload = response['token'].split('.')[1];
      String decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);

      Navigator.pushNamed(context, '/dashboard');
    }
  } catch (e) {
    Logger().e('Erreur lors de la vérification du code tiers: $e');
  }
}

// Mot de passe oublié
Future<void> missingPassword(String email, BuildContext context) async {
  try {
    await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/p/missing-password',
      needsToken: false,
      body: {'email': email},
      context: context,
    );
  } catch (e) {
    Logger().e('Erreur lors de la récupération du mot de passe: $e');
  }
}
