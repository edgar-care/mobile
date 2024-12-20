// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:edgar_pro/services/request.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgar/widget.dart';

Future<List<dynamic>> login(
    String email, String password, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/d/login',
      body: {'email': email, 'password': password},
      needsToken: false,
      context: context,
    );
    if (response['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);
      final encodedPayload = response['token'].split('.')[1];
      final decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);
      const TopSuccessSnackBar(message: 'Connecté à l\'application')
          .show(context);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/dashboard');
      return [];
    } else {
      return response['Methods'];
    }
  } catch (e) {
    const TopErrorSnackBar(message: 'Les identifiants ne correspondent pas !')
        .show(context);
    return [];
  }
}

Future<void> missingPassword(String email, BuildContext context) async {
  try {
    await httpRequest(
      type: RequestType.post,
      endpoint: 'auth/d/missing-password',
      needsToken: false,
      body: {'email': email},
      context: context,
    );
    TopSuccessSnackBar(message: 'Email envoyé veuillez regarder vos mail')
        .show(context);
  } catch (e) {
    Logger().e('Erreur lors de la récupération du mot de passe: $e');
  }
}

Future resetPassword(String password, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/dashboard/devices',
    body: {'new_password': password},
    needsToken: true,
    context: context,
  );
  if (response != null) {
    return response['devices'];
  }
  return [];
}

Future sendEmailCode(String email, BuildContext context) async {
  await httpRequest(
    type: RequestType.post,
    endpoint: '/auth/sending_email',
    body: {'email': email},
    needsToken: false,
    context: context,
  );
}

Future checkEmailCode(
    String email, String password, String code, BuildContext context) async {
  TopLoadingSnackBar().show(context);
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/auth/d/email_2fa',
    body: {'email': email, 'password': password, 'token_2fa': code},
    needsToken: false,
    context: context,
  );
  if (response != null) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', response['token']);
    final encodedPayload = response['token'].split('.')[1];
    final decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
    TopSuccessSnackBar(message: 'Connecté à l\'application').show(context);
  }
}

Future checkBackUpCode(
    String email, String password, String code, BuildContext context) async {
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/auth/d/backup_code_2fa',
    body: {'email': email, 'password': password, 'backup_code': code},
    needsToken: false,
    context: context,
  );
  if (response != null) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', response['token']);
    final encodedPayload = response['token'].split('.')[1];
    final decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pushNamed(context, '/dashboard');
  }
}

Future checkThirdPartyCode(
    String email, String password, String code, BuildContext context) async {
  TopLoadingSnackBar().show(context);
  final response = await httpRequest(
    type: RequestType.post,
    endpoint: '/auth/d/third_party_2fa',
    body: {'email': email, 'password': password, 'token_2fa': code},
    needsToken: false,
    context: context,
  );
  if (response != null) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', response['token']);
    final encodedPayload = response['token'].split('.')[1];
    final decodedPayload =
        utf8.decode(base64.decode(base64.normalize(encodedPayload)));
    prefs.setString('id', jsonDecode(decodedPayload)["id"]);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(context, '/dashboard');
    TopSuccessSnackBar(message: 'Connecté à l\'application').show(context);
  } else {
    TopErrorSnackBar(message: 'Code invalide').show(context);
    return;
  }
}

Future<void> register(Map<String, dynamic> dInfo, BuildContext context) async {
  try {
    final response = await httpRequest(
      type: RequestType.post,
      endpoint: '/auth/d/register',
      body: {
        "email": dInfo["email"],
        "password": dInfo["password"],
        "name": dInfo["name"],
        "firstname": dInfo["firstname"],
        "address": {
          "street": dInfo["adress"],
          "zip_code": dInfo["postalCode"],
          "country": dInfo["country"],
          "city": dInfo["city"]
        }
      },
      needsToken: false,
      context: context,
    );
    if (response != null && response['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response['token']);
      final encodedPayload = response['token'].split('.')[1];
      final decodedPayload =
          utf8.decode(base64.decode(base64.normalize(encodedPayload)));
      prefs.setString('id', jsonDecode(decodedPayload)["id"]);
      const TopSuccessSnackBar(message: 'Connecté à l\'application')
          .show(context);
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/dashboard');
    } else {
      return response['2fa_methods'];
    }
  } catch (e) {
    const TopErrorSnackBar(message: 'Les identifiants ne correspondent pas !')
        .show(context);
  }
}
